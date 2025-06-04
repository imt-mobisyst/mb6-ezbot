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
	pkill openvpn >/dev/null 2>&1

	cd /opt/ezw/etc/openvpn

	openvpn --config /opt/ezw/etc/openvpn/*.conf &
else
	pkill openvpn
fi

if [ $? -ne 0 ]; then
	echo ""
	echo "Failed !"
	exit 1
fi

echo ""
echo "Done !"
