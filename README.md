# Invoke-AccessCheck
a simple powershell wrapper to automate checking a user's access around the network

- check for access using SMB: `Invoke-AccessCheck -SMB` *this method uses the technique explained here: https://www.linkedin.com/posts/rafa-pimentel_once-you-compromise-a-new-user-in-active-activity-7131366070912720896-YKF8?utm_source=share&utm_medium=member_desktop* by Rafael Pimentel

- check for access using PSRemoting: `Invoke-AccessCheck -PSRemoting` *this method runs the command hostname on all the machines the one returns output is a hit*

- check for access on a seperate Domain: `Invoke-AccessCheck -Domain contoso.local -PSRemoting` <-- this cool feature is added by Rafeal Pimental author of the post above himself !

**the script relies on ActiveDirectory Module, if it didn't find it, it pulls it and imports automatically**
