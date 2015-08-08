#!/bin/bash

# this file is for global variables and function libraries
# you will need to source this file locally, or on a mounted network share when code is executed
# do not use exit status in this source, it will kill the process of the parent script

###############################################################################################
#
#  Global variables go bleow
#
############################################################################################


# grabs the current user who owns /dev/console

currentUser=$(ls -l /dev/console | awk '{ print $3 }')

# local user accounts with UID of 501 to 999
# this builds an array of all local user accounts betwen this UID range on the local Mac

localUsers=$(dscl . list /Users UniqueID | awk '$2 > 500 && $2 < 1000 { print $1 }')

# listing all mobile/network users 
# this will display all connected and synchronized protable users on a Mac
# this only works for accounts syncrhonized as dscl is pointed towards the local BSD database

netUsers=$(dscl . list /Users UniqueID | awk '$2 > 1000 { print $1 }')

# allUsers will list all users above UID 500, it is assumed any management account 
# used for IT or otherwise will have a UID lower than 500

allUsers=$(dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }')

# varialbes for enrollment scripts below here:

invitationCode=''
jssURL=''
receiptFilePath=''


##########################################################################################
#
#  functions go below
#  read each function's comments to know how to use them
#  you must source this file to use the below functions
#
###########################################################################################

# the question you want to display for the yes|no function

# usage of this function, your parent script must have a variabled named message, that has quoted text to 
# ask the end user a question.   For example:
# message="hello world"
# when you call the yesNo function it will output an answer of "yes" or "no" in lower case
#  from there you can use the logic to execute other code

# start yesNo function

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

# check the JSS and enroll devices with the following functions, must have varialbes above set.

checkJSS() {
	ping -c 1 ${jssURL}
	if [[ $(echo $?) != 0 ]]
	  then "echo cannot connect to the JSS, exiting..."
	  exit 1
	fi
}

enrollJSS() {

	if [[ -e '/Library/Application Support/JAMF/JAMF.keychain' ]]
	  then echo "need to back up the old keychain, just in case.."
	  mv /Library/Application\ Support/JAMF/JAMF.keychain /Library/Application\ Support/JAMF/JAMF.keychain.old
	fi

	jamf enroll -invitation ${invitationCode}


	if [[ $(echo $?) != 0 ]]
	  then echo "enrollment failed..." > ${receiptFilePath}
	  jamf recon
	  exit 1
	  else "echo enrollment was a success.."
	  rm ${receiptFilePath}
	  jamf recon
	fi
}
