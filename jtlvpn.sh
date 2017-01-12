#!/bin/bash
# set -x
echo "FYI: Make sure you've set your VPN connection properly in this script"
# Enter the UUID of your vpn connection in quotes below
VPNUUID='7379e0f1-765e-4596-934f-7c5af2591069'
echo "$VPNUUID, should match the second column of the following output:"
# List all avalible vpn connectioins so user can copy data
nmcli con show | grep 'vpn'
echo "***********************************************"

echo "Last Connection Attempt Was..."
nmcli con show $VPNUUID | grep vpn.data | grep -oP '(?<=gateway).*'
echo "Retry last? (y=yes, else=no)"
read reTryLast
if [[ $reTryLast = "y" ]]
then
	echo "Retrying last connection..."
	startD=$(date +"%b %d %H:%M:%S")
	result=$(nmcli con up $VPNUUID 2>&1)

	echo $result
	test1=$(echo "$result" | grep ^Error)
	size=${#test1}
	endD=$(date +"%b %d %H:%M:%S")
	if [[ $size = 0 ]]
	then
	  # No Errors
		userChoice=false
		while [[ $userChoice != 1 ]]
		do
		  echo -n "Enter 1 to Exit/Disconnect > "
		  read userChoice
		done
		# Disconnect VPN
		nmcli con down $VPNUUID
	else
		# Error
		echo $test1
		echo "Calling Disconnect again to deal with vpn-retrying when trying to connect to vpn someone is already in."
		echo "Check logs at /var/log/syslog, tail -f /var/log/syslog, or tail -n 50 /var/log/syslog"
		echo "************************************************************************************************"
		echo "Showing Logs from $startD to $endD**************************************************************"
		echo "************************************************************************************************"
		sed -n "/$startD/,/$endD/p" /var/log/syslog
		nmcli con down $VPNUUID
	fi

else 
	echo "***********************************************"
	echo -n "Enter VPN IP Address > "
	read vpnIP
	echo -n "Enter VPN Password > "
	read vpnPass
	echo "Trying $vpnIP with $vpnPass"
	startD=$(date +"%b %d %H:%M:%S")
	# Edit connection details
	nmcli con modify $VPNUUID vpn.data "user=admin, gateway=$vpnIP, password-flags=0, require-mppe=yes" vpn.secrets password=$vpnPass 
	# Start connection and wait for input to disconnect 
	result=$(nmcli con up $VPNUUID 2>&1)

	echo $result
	test1=$(echo "$result" | grep ^Error)
	size=${#test1}
	endD=$(date +"%b %d %H:%M:%S")
	if [[ $size = 0 ]]
	then
	  # No Errors
		userChoice=false
		while [[ $userChoice != 1 ]]
		do
		  echo -n "Enter 1 to Exit/Disconnect > "
		  read userChoice
		done
		# Disconnect VPN
		nmcli con down $VPNUUID
	else
		echo $test1
		echo "Calling Disconnect again to deal with vpn-retrying when trying to connect to vpn someone is already in."
		echo "Check logs at /var/log/syslog, tail -f /var/log/syslog, or tail -n 50 /var/log/syslog"
		echo "************************************************************************************************"
		echo "Showing Logs from $startD to $endD**************************************************************"
		echo "************************************************************************************************"
		sed -n "/$startD/,/$endD/p" /var/log/syslog		
		nmcli con down $VPNUUID
	fi

fi
