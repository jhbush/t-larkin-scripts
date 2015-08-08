#!/bin/bash

# proof of concept AppleScript interaction to end user in bash

# declare any bash variables here

currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

##### begin user interaction #####

theAnswer=$(/usr/bin/osascript <<AppleScript
tell application "Finder"
 activate
 display dialog "Do you want to know the meaning of the universe, ${currentUser}?" buttons {"No","Yes"} default button 2
  if the button returned of the result is "No" then
   set theAnswer to No
  end if
end tell
AppleScript)

/bin/echo "${theAnswer}"

if [[ ${theAnswer} == "no" ]]

  then /bin/echo "They obviously have read the Hitcherhiker's Guide and know it is 42"
  else /bin/echo "The Answer is 42"
fi

exit 0