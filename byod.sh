#!/bin/bash

# use applescript to ask user if their device is BYOD
# If they click yes, put a text file in the system to flag it as BYOD
# use Extension attribute to check if the file exists to flag into BYOD smart group

# ask the user if it is a BYOD Device

theAnswer=$(/usr/bin/osascript <<-AppleScript
tell application "Finder"
	activate
	display dialog "Is this computer a personal BYOD computer?" buttons {"Yes", "No"}
	if result = {button returned:"Yes"} then
	set theAnswer to Yes
	end if
end tell
AppleScript)

/bin/echo ${theAnswer}

# now use bash to insert that file somewhere
# if the answer is yes, write to a log file and recon for extension attribute reporting
# if they click no, remove the log to remove it from the group

if [[ ${theAnswer} == "yes" ]] 

  then /bin/echo "BYOD Device" > /private/var/byod.txt
  /bin/sleep 3
  /usr/sbin/jamf recon
  
  else /bin/echo "corporate device, exiting script..."
  /bin/rm /private/var/byod.txt
  /usr/sbin/jamf recon
  
fi

exit 0

