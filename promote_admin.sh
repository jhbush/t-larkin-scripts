#!/bin/bash

# use casper framework to add currently logged in user to the admin group at login
# this will only work with the Casper framework using built in parameters

/usr/sbin/dseditgroup -o edit -a $3 -t user admin

exit 0