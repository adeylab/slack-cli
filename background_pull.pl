#!/usr/bin/perl

$die = "

ARGV0 = end point (mon, day, or year)
        (eg. mon=June or day=31)
ARGV1 = time (seconds) between iterations
ARGV2 = (if specified, slack channel to post to)
        (must have slack cli setup)

";

if (!defined $ARGV[1]) {die $die};
($cat,$value) = split(/=/, $ARGV[0]);

$exit = 0; $pull_ct = 0;
while ($exit == 0) {
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	if ($cat =~ /^m/i) {
		if (lc(substr($value,0,3)) eq lc(substr($mon,0,3))) {$exit = 1};
	} elsif ($cat =~ /^d/i) {
		if ($value >= $mday) {$exit = 1};
	} elsif ($cat =~ /^y/i) {
		if ($value >= $year) {$exit = 1};
	} else {die "ERROR: Must specify month day or year!\n$die"};
	if ($exit > 0) {
		if (defined $ARGV[2]) {
			system("slack -c \"Ending auto pull ($ARGV[0]), $pull_ct total pulls\" $ARGV[2]");
		}
	} else {
		system("git reset --hard");
		open PULL, "git pull |";
		$in = <PULL>; close PULL;
		if ($in !~ /^Already/) {
			$pull_ct++;
			if (defined $ARGV[2]) {
				system("slack -c \"Auto git pull completed.\" $ARGV[2]");
			}
		}
		sleep($ARGV[1]);
	}
}
exit;