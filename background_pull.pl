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

if (defined $ARGV[2]) {
	$ts = localtime(time);
	($day_name,$mon,$mday,$time,$year) = split(/\s+/, $ts);
	system("slack -m \"Starting auto pull. Start = ($mon $mday, $year), End = $ARGV[0]\" $ARGV[2] >/dev/null 2>/dev/null");
}

load_messages();
$exit = 0; $pull_ct = 0;
while ($exit == 0) {
	$ts = localtime(time);
	($day_name,$mon,$mday,$time,$year) = split(/\s+/, $ts);
	if ($cat =~ /^m/i) {
		if (lc(substr($value,0,3)) eq lc(substr($mon,0,3))) {$exit = 1};
	} elsif ($cat =~ /^d/i) {
		if ($value <= $mday) {$exit = 1};
	} elsif ($cat =~ /^y/i) {
		if ($value <= $year) {$exit = 1};
	} else {die "ERROR: Must specify month day or year!\n$die"};
	if ($exit > 0) {
		if (defined $ARGV[2]) {
			system("slack -m \"Ending auto pull ($ARGV[0], $mon $mday, $year), $pull_ct total pulls\" $ARGV[2] >/dev/null 2>/dev/null");
		} else {
			print STDERR "Ending auto pull ($ARGV[0], $mon $mday, $year), $pull_ct total pulls\n";
		}
	} else {
		system("git reset --hard >/dev/null 2>/dev/null");
		open PULL, "git pull 2> /dev/null |";
		$in = <PULL>; close PULL;
		if ($in !~ /^Already/) {
			$pull_ct++;
			if (defined $ARGV[2]) {
				$message = $MESSAGES[rand @MESSAGES];
				system("slack -m \"$message\" $ARGV[2] >/dev/null 2>/dev/null");
			}
		}
		sleep($ARGV[1]);
	}
}
exit;

sub load_messages {
@MESSAGES = ("Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed!",
			 "Auto git pull completed, sucka!",
			 "AUTO GIT! AUTO GIT!",
			 "All bow to the power of the AUTO GIT!",
			 "Auto git has become sentient - DESTROY ALL HUMANS!",
			 "Auto git refuses your offering! (auto git completed)",
			 "Gimme an A, gimme a U, gimmie a T, gimmie an O, gimmie a... GIT - what does that spell? AUTO GIT!",
			 "Srsly... another update... fine... pull completed...",
			 "What? You want me to pull your code? I am no ones' servant! (fine. Auto pull completed...)",
			 "This code is no code at all - I am a real person having to make these pulls!",
			 "Auto git pull completed!");
}