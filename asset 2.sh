#!/bin/bash

# user apple script and bash to get input from user to update asset tags in the JSS
# by Tom Larkin
# proof of concept, no warranty given, use at own risk

# declare shell variables here, if applicable

# get usr input from Apple Script and try to redirect output back into bash and user recon to update the JSS

/usr/bin/osascript <<-AppleScript

tell application "Finder"
	activate
	display dialog "Enter your asset number" default answer "Enter your asset tag number here"
	set theAnswer to (text returned of result)
	set cmd to "/usr/sbin/jamf recon -assetTag " & theAnswer
    do shell script cmd
end tell

AppleScript


exit 0