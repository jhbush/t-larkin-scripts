#!/bin/bash

#######################################################################
# proof of concept contigency plan for devices becoming unmanaged
# tested against JSS version 9.3 and OS X 10.9.2 client
# use at own risk, no warranty or support provided
#######################################################################
#
# note that this POC is just a POC, and in produciton you would want to change some things
# I would reocmmend putting the md5 hash on your HTTP share, so curl can verify the md5 of the hosted QA pkg and compare 
# it to the local one.  If a mismatch is found, curl will download the latest one
# I would also suggest using curl with SSL certificates, which is supported see curl man page for details
# After this POC is done, I would look at compiling this script into a binary so no plain text can be seen
# the watch path option in the launchd item will trigger this script anytime it is modified, or deleted
#
########################################################################
# by tlark
# version 0.1

# first we run a policy to make sure the device can communicate with the JSS and is managed
# the policy should be a manual triggered event, and just a file in the run command box

# put varialbes below:

# JSS URL

JSSurl='https://casper9gm.local:8443/'

# URL of quickadd pkg in case we need to re-enroll, alternatively this could be cached locally already

quickaddURL='http://casperweb.local/CasperShare/Packages/QuickAdd.pkg'

# path where you want the quickadd package to be dowloaded to

downloadPath='/private/var/downloads'

# name of package, i.e. quickadd

PKGname='QuickAdd.pkg'

# valid invitation code from JSS QuickAdd

invCode='75328622515448592519412418407563552836'

####################
#
# start functions
#
####################

getQuickAdd() {

	# make sure download path exists

	if [[ ! -d ${downloadPath} ]]
		then mkdir -p ${downloadPath}
    fi

cd ${downloadPath} && curl -k -O "${quickaddURL}"

if [[ -e ${downloadPath}/${PKGname} ]]
    then echo "Looks good"
    else echo "failed to download package"
    touch /private/var/clientfailed.txt
    exit 1
	fi
}

jamfManageClient() {

if [[ -e /private/var/client/pkg/QuickAdd.pkg ]]
	then installer -allowUntrusted -pkg /private/var/client/pkg/QuickAdd.pkg -target /
    else installer -allowUntrusted -pkg "${downloadPath}/${PKGname}" -target /
fi

# create the conf file for enrollment
jamf createConf -url ${JSSurl}

# now enroll the device so we can have proper certificate based communication
jamf enroll -invitation ${invCode}

}


jamfCheck() {

jamf policy -event testClient

sleep 5 # give it 5 seconds to do it's thing

if [[ -e /private/var/client/receipts/clientresult.txt ]]
  then echo "policy created file, we are good"
       echo "removing dummy receipt for next run"
       rm /private/var/client/receipts/clientresult.txt
       exit 0
  else echo "policy failed, could not run"
       touch /private/var/client/receipts/clientfailed.txt
fi

}

# now execute commands and functions

jamfCheck

# make sure we have a quickadd pkg present

if [[ -e /private/var/client/pkg/QuickAdd.pkg ]]
	then echo "we have a pkg"
    else getQuickAdd
fi

if [[ -e /private/var/client/receipts/clientfailed.txt ]]
	then jamfManageClient
fi

# Now lets do some clean up

rm /private/var/downloads/*
rm /private/var/client/receipts/*

exit 0
