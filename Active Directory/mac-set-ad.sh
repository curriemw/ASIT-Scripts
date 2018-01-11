#!/bin/sh

strComputerName="$1"

DEFAULT_OU="ou=Computers,ou=Artsci,ou=Colleges,dc=ad,dc=uc,dc=edu"
DOMAIN_NAME="ad.uc.edu"
ADMIN_GROUPS="AD\ARTSCI Admins,AD\Enterprise Admins,AD\Domain Admins"
PROFILE_PATH="/Users/*"

printf "AD Network Administrator Username: "
read ADUSER
printf "AD Network Administrator Password: "
read -s ADPASS

echo ""

if [ "${strComputerName}"  == "" ]; then
                strComputerName=`/usr/sbin/scutil --get ComputerName`
fi

scutil --set ComputerName $strComputerName
scutil --set LocalHostName $strComputerName
scutil --set HostName $strComputerName
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName $strComputerName
echo "ComputerName Set as $strComputerName"

#Forcefully remove from AD
echo "Forcefully unbinding from AD domain"

dsconfigad -force -remove -u $ADUSER -p $ADPASS

echo "Binding to ad.uc.edu"

dsconfigad -add $DOMAIN_NAME -computer $strComputerName -groups "$ADMIN_GROUPS" -ou "$DEFAULT_OU" -alldomains disable -force -u $ADUSER -p $ADPASS

echo "Updating Search Policy"

dscl /Search -delete / CSPSearchPath "/Active Directory/AD/All Domains"
dscl /Search -create / SearchPolicy CSPSearchPath
dscl /Search -append / CSPSearchPath "/Active Directory/AD/ad.uc.edu"
dscl /Search/Contacts -delete / CSPSearchPath "/Active Directory/AD/All Domains"
dscl /Search/Contacts -create / SearchPolicy CSPSearchPath
dscl /Search/Contacts -append / CSPSearchPath "/Active Directory/AD/ad.uc.edu"

echo "Changing time server"
systemsetup -setnetworktimeserver ad.uc.edu
