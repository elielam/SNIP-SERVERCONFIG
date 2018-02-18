#!/bin/bash
echo '######## CONFIG NETWORK ########'
echo ''
echo 'CONFIG STATIC IP'

if [ $1 = "-h" ]; then
     echo 'This script need arguments to be run , the structure is like that :'
     echo 'sh 01-configNetwork.sh [ipv4/ipv6/both] [ipv4/ipv6] [ipv6]'
fi

if [ $1 = "ipv4" ]; then
     ipv4Adress=$2
elif [ $1 = "ipv6" ]; then
	echo 'ipv6'
     ipv6Adress=$2
elif [ $1 = "both" ]; then
     ipv4Adress=$2
     ipv6Adress=$3
fi

echo ''

read -p 'Enter interface name : ' interface

echo ''

sudo route -n

echo ''

read -p 'Enter gateway adress : ' gateway

echo ''

	{
    		echo '# This file describes the network interfaces available on your system'
		echo '# For more information, see netplan(5).'
		echo 'network:'
		echo ' version: 2'
		echo ' renderer: networkd'
		echo ' ethernets:'
		echo "   $interface:"
		echo '     dhcp4: no'
		echo '     dhcp6: no'

		if [ $1 = "ipv4" ]; then
    			echo "     addresses: [$ipv4Adress/24]"
		elif [ $1 = "ipv6" ]; then
	     		echo "     addresses: [$ipv6Adress/64]"
		elif [ $1 = "both" ]; then
	    		echo "     addresses: [$ipv4Adress/24, '$ipv6Adress/64']"
		fi

		echo "     gateway4: $gateway"
		echo '     nameservers:'
		echo '       addresses: [8.8.8.8,8.8.4.4]'
	} >/etc/netplan/01-netcfg.yaml

echo 'File 01-netcfg.yaml was created in /etc/netplan/'

echo ''

echo 'NETPLAN DEBUG'
echo ''
sudo netplan --debug generate

echo ''

echo 'NETPLAN APPLY'
sudo netplan apply
echo ''

echo 'CONFIG FINISHED'
echo ''

# Modify in future to test if its ipv4 or ipv6 or both and display appropriate message
echo "Interface $interface is know configured on $ipv4Adress"
echo "The gateway is $gateway"

echo ''
