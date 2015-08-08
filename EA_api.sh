#!/bin/bash

#Global variables
index="0"
array=()
ea_name=""
ea_value=""
jss_url=""
jss_username=""
jss_password=""

get_ea_name(){
# query user for short name to change
echo "Please enter the name of the Extention Attribute you would like to change:"
read ea_name
echo "You have entered: $ea_name.  Is this correct? (y/n)"
read VERIFY_NAME
case $VERIFY_NAME
	in
		y|Y)
			get_ea_value
			continue;;
		n|N)
			get_ea_name
			continue;;
		*)
			echo "Unrecognized option - enter \"y\" or \"n\""
			get_ea_name
			continue;;
esac
}

get_ea_value(){
# query user for short name to change
echo "Please enter the new value for the Extention Attribute you would like to change:"
read ea_value
echo "You have entered: $ea_value.  Is this correct? (y/n)"
read VERIFY_VALUE
case $VERIFY_VALUE
	in
		y|Y)
			get_jss_url
			continue;;
		n|N)
			get_ea_value
			continue;;
		*)
			echo "Unrecognized option - enter \"y\" or \"n\""
			get_ea_value
			continue;;
esac
}

get_jss_url(){
# query user for short name to change
echo "Please enter your JSS URL (Note: with https:// and :8443):"
read jss_url
echo "You have entered: $jss_url  Is this correct? (y/n)"
read VERIFY_JSSURL
case $VERIFY_JSSURL
	in
		y|Y)
			get_jss_user
			continue;;
		n|N)
			get_jss_url
			continue;;
		*)
			echo "Unrecognized option - enter \"y\" or \"n\""
			get_jss_url
			continue;;
esac
}

get_jss_user(){
# query user for short name to change
read -p "Please enter your JSS Username:" jss_username
echo "You have entered: $jss_username.  Is this correct? (y/n)"
read VERIFY_JSSUSER
case $VERIFY_JSSUSER
	in
		y|Y)
			get_jss_pass
			continue;;
		n|N)
			get_jss_user
			continue;;
		*)
			echo "Unrecognized option - enter \"y\" or \"n\""
			get_jss_user
			continue;;
esac
}

get_jss_pass(){
# query user for short name to change
read -s -p "Please enter JSS User's Password:" jss_password
echo ""
# echo "You have entered: $jss_password.  Is this correct? (y/n)"
read -s -p "Please verify your JSS User's Password:" VERIFY_JSSPASS

if [ "${jss_password}" == "${VERIFY_JSSPASS}" ] 
then
	change_ea
else
	echo "Passwrods do not match, please try again"
	get_jss_pass
fi

#case $VERIFY_JSSPASS
#	in
#		y|Y)
#			change_ea
#			continue;;
#		n|N)
#			get_jss_pass
#			continue;;
#		*)
#			echo "Unrecognized option - enter \"y\" or \"n\""
#			get_jss_pass
#			continue;;
#esac
}

change_ea(){

/usr/bin/curl -k -v -u ${jss_username}:${jss_password} ${jss_url}/JSSResource/computers -X GET -o /tmp/computers.xml
computers=`/bin/cat /tmp/computers.xml | xpath //computers/size | sed -e 's/\<size>//g; s/\<\/size>//g'`

#create temp EA file
echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?><computer><extension_attributes><attribute><name>'"${ea_name}"'</name><value>'"${ea_value}"'</value></attribute></extension_attributes></computer>' > /tmp/ea.xml

#Get JSS ID of each computer and submit EA XML
while [ ${index} -lt ${computers} ]
do
	index=$[$index+1]
	id=`/bin/cat /tmp/computers.xml | xpath //computers/computer[${index}]/id | sed -e 's/\<id>//g; s/\<\/id>//g'`
	/usr/bin/curl -k -v -u ${jss_username}:${jss_password} ${jss_url}/JSSResource/computers/id/${id}/subset/extension_attributes -T "/tmp/ea.xml" -X PUT
done


#Submit data and cleanup
rm /tmp/computers.xml
rm /tmp/ea.xml

exit 0
}

get_ea_name