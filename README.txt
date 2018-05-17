Wrapper to directly post messages and files to a Slack workspace.
To use this, log into slack in your web browser and go here:

   https://api.slack.com/custom-integrations/legacy-tokens
   
Then click the "Create Token" button. You can copy the token and use it
as the option -t, OR, save it in a file called ".slack_token" in your
home directory that has the token. Be sure to run:

   'chmod 600 .slack_token'

To ensure no one else can read it. The file should have the workspace name
a tab and then the token.   

Usage: slack [options] [channel]

Options: (at least one of -m or -F must be specified)
   -m   [STR]   Message to post (in double quotes)
   
   -F   [STR]   File to post (overrides -m message)
   -c   [STR]   Initial comment on file (in double quotes)
   -T   [STR]   Title of file (in double quotes)

   -t   [STR]   Slack token (if not in ~/.slack_token file)
   -w   [STR]   Token to use (default is first)
                (can specify the name of the token, ie workspace
                 or the line number)

For arguments in double quotes, it is fine to include spaces, but some
special characters (e.g. !) are not compatible.
