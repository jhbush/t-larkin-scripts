#!/bin/bash 

#################################
# advanced inventory script to populate JSS data via recon command
#
# set variables here that you wish recon to populate
# Note this requires the Casper Suite
#
#  USE AT YOUR OWN RISK, NO WARRANTY PROVIDED
#  by Thomas Larkin
#  http://tlarkin.com
#
#  This is rough draft, version 0.1
##################################

# this is designed to run as a log in hook
# this assumes the short name is also the email name


# depending on how you configure your user names you may need to alter the script

RealName=`/usr/bin/dscl . read /Users/$3 | /usr/bin/awk '/RealName/ { print $2 $3 }'`

ShortName=`/usr/bin/dscl . read /Users/$3 | /usr/bin/awk '/RecordName/ { print $2 }'`

email="@mycompany.com"

# now recon the info into the jss

/usr/bin/jamf recon -realName $RealName -endUsername $ShortName -email $3$email

exit 0