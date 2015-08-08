# invoke Applescript to interact with user via self service for them to choose which 
# existing user account to migrate to the new user account

oldUser=`/usr/bin/osascript <<-AppleScript
tell application "Finder"
	activate
	display dialog "Please enter a user account you wish to migrate to this account from:
	${userList}" default answer " "
	set theAnswer to (text returned of result)
	set oldUser to "/Users/" & theAnswer
end tell
AppleScript`

/bin/echo "oldUser: ${oldUser}"