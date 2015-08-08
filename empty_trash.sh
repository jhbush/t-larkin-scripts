#!/bin/bash


# get the total amount of disk space the current user's trash has

currentUser=$(ls -l /dev/console | awk '{ print $3 }')

trashSpace=$(du -h -c /Users/${currentUser}/.Trash/ | awk '/total/ { print $1 }')

# set the emptry trash message for the end user

message="Hello ${currentUser}, system maintenance has determined your trash is starting to fill up.  Please select Yes to empty the trash.  WARNING:  This will permanently empty all the contents of the your trash."

# determine if it is Megabytes or Gigabytes

case ${trashSpace} in

  *G ) size='gigs';;
  * ) echo "trash is under 1gig"
esac

# yesNo function

yesNo () {
	
	# prompt user for yes|no answers

theAnswer=$(/usr/bin/osascript <<AppleScript
tell application "Finder"
 activate
 display dialog "Hello ${currentUser}, ${question}" buttons {"No","Yes"} default button 2
  if the button returned of the result is "No" then
   set theAnswer to No
  end if
end tell
AppleScript)

/bin/echo "${theAnswer}"

if [[ ${theAnswer} == "no" ]]
	then theAnswer="no"
    else theAnswer="yes"
fi
}

# now if the size is in gigs, not matter how many, prompt to empty trash

if [[ size == 'gigs' ]]
  then yesNo
fi

if [[ ${theAnswer} == 'yes' ]]
  then rm -rf /Users/${currentUser}/.Trash/
fi

exit 0