#!/bin/bash

usage() {
	echo "Usage: $0 <start|stop>"
}

if [ "$#" -ne 1 ]; then
	usage
	exit 1
fi

# Check if started as sudo
if [ $(/usr/bin/id -u) -ne 0 ]; then
	echo "Error : Insufficient privileges !"
	exit 1
fi

if [ "$1" == "start" ]; then
	HIDDEN_SSID=1
	echo ""
	read -p "Hidden SSID ? " -n 1 -r
	echo ""
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		HIDDEN_SSID=0
	fi

	if [ $HIDDEN_SSID -eq 0 ]; then
		echo "Scanning..."
		nmcli d wifi list
	fi

	echo ""
	read -p "Enter SSID : " ACCESS_POINT_SSID

	read -rs -p "Enter PSK : " ACCESS_POINT_PASSWORD

	echo ""
	echo ""
	echo -n "Connecting...."
	echo ""
	sleep 5
	#nmcli device wifi connect "$ACCESS_POINT_SSID" hidden yes password "$ACCESS_POINT_PASSWORD" ifname wlan1
	nmcli con delete WLAN1 >/dev/null 2>&1
	nmcli con add type wifi con-name WLAN1 ifname wlan1 ssid "$ACCESS_POINT_SSID"
	nmcli con mod WLAN1 wifi-sec.key-mgmt wpa-psk
	nmcli con mod WLAN1 wifi-sec.psk "$ACCESS_POINT_PASSWORD"
	if [ $HIDDEN_SSID -eq 1 ]; then
		nmcli con mod WLAN1 802-11-wireless.hidden yes
	fi
	nmcli --ask con up WLAN1
else
	nmcli con delete WLAN1
fi

if [ $? -ne 0 ]; then
	echo ""
	echo "Failed !"
	exit 1
fi

echo ""
echo "Done !"
