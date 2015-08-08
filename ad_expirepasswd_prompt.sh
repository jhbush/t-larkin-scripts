#!/bin/bash

# AD password expiry notification script
# by tlark
# no warranty given, this is only proof of concept tested on cached AD profiles on OS X 10.9.2

# this script grabs the current user by detecting who owns /dev/console

currentUser=$(ls -l /dev/console | awk '{print $3}')

# message you would like to display to the user
question='your AD password is going to expire in ${daysremaining} would you like to change it now?'


todayUnix=$(date "+%s") # today's date on OS X in epoch time

pwdExpDays='42' # default value for when you rotate passwords in AD, set this to reflect when AD is set via GPO to expire a password

# depending on your environment you may need to use /Search in your dscl query or the full AD path
# or you can point it to the local node if everything is cached
# there is also a SMBPasswordLastSet but not sure if it syncs with pwdLastSet which is the legit AD attribute

ADpasswdLastSet=$(dscl /Active\ Directory/AD/All\ Domains read /Users/${currentUser} pwdLastSet | awk '{print $2}')

lastpwdUnix=$(expr ${ADpasswdLastSet} / 10000000 - 11644473600) # math to convert LDAP time stamp to epoch

diffUnix=$(expr ${todayUnix} - ${lastpwdUnix}) # math to get the current epoch date minus the LDAP to Epoch timestamp

diffdays=$(expr ${diffUnix} / 86400) # converts seconds into days, will return 0 if not enough seconds to equal a day

daysremaining=$(expr ${pwdExpDays} - ${diffdays}) # math to get days remaining

# functions go here to be executed dependeding on user interaction

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

changePasswd() {
	
osascript <<AppleScript
tell application "System Preferences"
 activate
  set the current pane to pane id "com.apple.preferences.users"
end tell
 tell application "System Events"
  tell process "System Preferences"
   click button "Change Password…" of tab group 1 of window "Users & Groups"
  end tell
 end tell
AppleScript
}


# compare days remaining to a value of 15
# if the user has more than 2 weeks to change their password this will exit

if [[ "${daysremaining}" -lt "15" ]]

	then yesNo
    else echo "password has more than two weeks"

fi

if [[ ${theAnswer} == 'yes' ]]
	then changePasswd
    else echo "User clicked no"

fi

exit 0