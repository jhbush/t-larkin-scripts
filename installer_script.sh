#!/bin/bash

# installer script, uses parameters $4 and $5

installURL="$4"

pkgName="$5"

downloadDir="$6"

# now veify the package type is an approved format

case ${pkgName} in
  *.pkg ) pkgType='pkg';;
  *.bash ) pkgType='bash';;
  *.py ) pkgType='python';;
  *.pl ) pkgType='perl';;
  *.sh ) pkgType='shell';;
  * ) echo "Unsupported pkg type";
      exit 1;
      ;;
 esac

 # now download the pkg
 
 echo "${4} is the URL, ${5} is the package, full path is ${4}${5}"

 curl -O ${4}${5} --output ${6}

 # now install it

 if [[ ${pkgType} == 'pkg' ]]
   then /usr/sbin/installer -pkg "${downloadDir}${pkgName}" -target /
 fi

 if [[ ${pkgType} == 'bash' ]] || [[ ${pkgType} == 'shell' ]]
   then /bin/sh "${downloadDir}${pkgName}"
 fi

 if [[ ${pkgType} == 'python' ]]
   then /usr/bin/python "${downloadDir}${pkgName}"
 fi

 if [[ ${pkgType} == 'perl' ]]
 	then /usr/bin/perl "${downloadDir}${pkgName}"
fi

exit 0