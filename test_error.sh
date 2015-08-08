#!/bin/bash

computerFile="/Users/tlarkin/Documents/computer_names.txt"

errorCheck() {

newCompName=`/usr/bin/awk -F, '/^'"t-lark"'/ { sub(/\r/,"");print $2;exit }' ${computerFile}`

/usr/bin/grep -l "t-lark" ${newCompName}

if [[ `/bin/echo "$?"` == 0 ]]
  then /bin/echo "record exists, proceeding with script..."
  else /bin/echo "record not found, exiting with logging..."
  /bin/echo "migration failed" > /Library/Reciepts/migrationfailed.txt
  exit 1
fi
}

errorCheck

exit 0