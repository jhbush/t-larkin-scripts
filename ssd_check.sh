#!/bin/bash

# create array of device nodes of mounted volumes

diskList=$(diskutil list | awk '/dev/ { print $1 }')

for i in ${diskList[@]} ; do

echo "<result>$(diskutil info $i | awk '/Media Type/ { print $NF }')</result>"
done

exit 0