#!/bin/bash

# collect Unix apps and write them to a flat file

# define variables here

UnixAppList=$(mdfind "kMDItemKind == 'Unix Executable File'" | grep -v 'Microsoft')

flatFile='/Library/Preferences/com.jamfsoftware.unixapps.plist'

# first see if the flat file exists, and is XML

if [[ -e ${flatFile} ]]
   then defaults read ${flatFile}
     if [[ $(echo $?) == 1 ]]
       then plutil -convert xml1 /Library/Preferences/com.jamfsoftware.unixapps.plist
     fi
else defaults write /Library/Preferences/com.jamfsoftware.unixapps.plist "UnixApps" -array
fi

# loop through files and write to list

for i in ${UnixAppList} ; do

defaults write /Library/Preferences/com.jamfsoftware.unixapps.plist "UnixApps" -array-add ${i}

done

exit 0



