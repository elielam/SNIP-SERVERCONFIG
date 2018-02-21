#!/bin/bash

dhcp=
ipv4=0
ipv6=0

if [[ $1 == "dhcp" ]] || [[ $2 == "dhcp" ]] || [[ $3 == "dhcp" ]] || [[ $4 == "dhcp" ]]; then
	dhcp=1
fi

if [[ $1 == "ipv4" ]] || [[ $2 == "ipv4" ]] || [[ $3 == "ipv4" ]] || [[ $4 == "ipv4" ]]; then
	ipv4=1
fi

if [[ $1 == "ipv6" ]] || [[ $2 == "ipv6" ]] || [[ $3 == "ipv6" ]] || [[ $4 == "ipv6" ]]; then
	ipv6=1
fi

if [[ $1 == "both" ]] || [[ $2 == "both" ]] || [[ $3 == "both" ]] || [[ $4 == "both" ]]; then
	ipv4=1
	ipv6=1
fi

if [[ $1 == "h" ]]; then
	echo
	echo "Configure Network" 
    echo " " 
    echo "options:" 
    echo "dhcp                configure network with DHCP" 
    echo "ipv4                configure network with IPV4" 
    echo "ipv6                configure network with IPV6" 
    echo "both        		  configure network with IPV4/IPV6" 
    echo " " 
    echo "exemple : ./script.sh ipv4" 
    echo
    exit 0
fi

function networkCreateConf {

	echo 'NETPLAN CONFIG'
	echo
	read -p 'Enter interface name : ' interface

	if [[ $dhcp != 1 ]]; then

		echo
		sudo route -n
		echo
		read -p 'Enter gateway adress : ' gateway

		if [[ $ipv4 == 1 ]]; then
			echo
			read -p 'Enter IPV4 adress ( x.x.x.x ) : ' ipv4Adress
		fi

		if [[ $ipv6 == 1 ]]; then
			echo
			read -p 'Enter IPV6 adress ( x.x.x.x ) : ' ipv6Adress
		fi

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

			if [[ $ipv4 == 1 ]] && [[ $ipv6 == 1 ]]; then
				echo "     addresses: [$ipv4Adress/24, '$ipv6Adress/64']"
			elif [[ $ipv4 == 1 ]]; then
				echo "     addresses: [$ipv4Adress/24]"
			elif [[ $ipv6 == 1 ]]; then
		    	echo "     addresses: [$ipv6Adress/64]"
			fi

			echo "     gateway4: $gateway"
			echo '     nameservers:'
			echo '       addresses: [8.8.8.8,8.8.4.4]'
		} >/etc/netplan/01-netcfg.yaml

	else

		echo
		read -p 'Use IPV4 DHCP ( yes or no ) : ' ipv4DHCPChoice
		echo
		read -p 'Use IPV6 DHCP ( yes or no ) : ' ipv6DHCPChoice

		{
	    	echo '# This file describes the network interfaces available on your system'
			echo '# For more information, see netplan(5).'
			echo 'network:'
			echo ' version: 2'
			echo ' renderer: networkd'
			echo ' ethernets:'
			echo "   $interface:"
			echo "     dhcp4: $ipv4DHCPChoice"
			echo "     dhcp6: $ipv6DHCPChoice"
		} >/etc/netplan/01-netcfg.yaml

	fi

	echo
	echo 'File 01-netcfg.yaml was created in /etc/netplan/'

}

function networkApply {

	echo 'NETPLAN DEBUG'
	echo
	sudo netplan --debug generate

	echo

	echo 'NETPLAN APPLY'
	sudo netplan apply
	echo

	echo 'CONFIG FINISHED'
	echo

	# Modify in future to test if its ipv4 or ipv6 or both and display appropriate message
	if [[ $ipv4 == 1 ]] && [[ $ipv6 == 1 ]]; then
		echo "Interface $interface is know configured on $ipv4Adress or $ipv6Adress"
	elif [[ $ipv4 == 1 ]]; then
		echo "Interface $interface is know configured on $ipv4Adress"
	elif [[ $ipv6 == 1 ]]; then
    	echo "Interface $interface is know configured on $ipv6Adress"
	fi
	echo "The gateway is $gateway"

}

echo
echo '######## CONFIG NETWORK ########'
echo
networkCreateConf
echo
networkApply
echo

unset dhcp
unset ipv4
unset ipv4Adress
unset ipv4DHCPChoice
unset ipv6
unset ipv6Adress
unset ipv6DHCPChoice
unset gateway
unset interface