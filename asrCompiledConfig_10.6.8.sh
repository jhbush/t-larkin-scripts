#!/bin/bash

#Define the target - $1 to automatically get this from Casper, /Volumes/Macintosh HD otherwise
target="$1"

#Automatically acquire the dev entry
devEntry=$(/usr/sbin/diskutil info "$target" | /usr/bin/grep "Device Node" | /usr/bin/awk '{print $3}')
echo "The dev entry for the disk to be restored: $devEntry"

#Acquire the original volume label
originalName=$(/usr/sbin/diskutil info "$target" | /usr/bin/grep "Volume Name" | /usr/bin/grep -o '[^:]*$'  | /usr/bin/tr -s " " | /usr/bin/sed 's/^[ ]//g')
echo "The disk name: $originalName will be retained upon restoring."

#Unmount the disk to prepare it for ASR
/usr/sbin/diskutil unmount $devEntry

#Perform the ASR copy
echo "Initiating restore process and waiting for connection..."
/usr/sbin/asr restore --source "/Volumes/CasperShare/CompiledConfigurations/10.6.8_base.dmg" -target "$devEntry" -erase -noprompt -timeout 0 -puppetstrings -noverify --verbose

#Mount the disk again
/usr/sbin/diskutil mount $devEntry

#Rename the disk to ensure that it's named with it's original name
/usr/sbin/diskutil rename $devEntry "$originalName"

exit 0