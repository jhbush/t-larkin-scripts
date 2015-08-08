#!/bin/sh

#create two partitions, one data and one for the OS

/usr/sbin/diskutil partitionDisk disk0 2 APMFormat HFS+ 'Macintosh HD' 50G HFS+ data 23G

echo 'done'
