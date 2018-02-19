#!bin/bash

dhcp=
ipv4=0
ipv6=0

while getopts "iqcv:tb:" OPTION
do
    case $OPTION in
        dhcp)
            dhcp=1
            ;;
        ipv4)
            ipv4=1
            ;;
        ipv6)
            ipv6=1
            ;;
        both)
            ipv4=1
            ipv6=1
            ;;
        \?)
            echo "Configure Network" 
            echo " " 
            echo "options:" 
            echo "-dhcp                configure network with DHCP" 
            echo "-ipv4                configure network with IPV4" 
            echo "-ipv6                configure network with IPV6" 
            echo "-both        		   configure network with IPV4/IPV6" 
            echo " " 
            echo "exemple : ./script.sh -ipv4" 
            exit 0
            ;;
    esac
done

function networkCreateConf {

	echo 'NETPLAN CONFIG'
	echo ''
	read -p 'Enter interface name : ' interface

	if [ "$dhcp" != 1 ]; then

		echo ''
		sudo route -n
		echo ''
		read -p 'Enter gateway adress : ' gateway

		if [ "$ipv4" == 1 ]; then
			echo ''
			read -p 'Enter IPV4 adress ( x.x.x.x ) : ' ipv4Adress
		fi

		if [ "$ipv6" == 1 ]; then
			echo ''
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

			if [ "$ipv4" == 1 && "$ipv6" == 1 ]; then
				echo "     addresses: [$ipv4Adress/24, '$ipv6Adress/64']"
			else [ "$ipv4" == 1 ]; then
				echo "     addresses: [$ipv4Adress/24]"
			else [ "$ipv6" == 1 ]; then
		    	echo "     addresses: [$ipv6Adress/64]"
			fi

			echo "     gateway4: $gateway"
			echo '     nameservers:'
			echo '       addresses: [8.8.8.8,8.8.4.4]'
		} >/etc/netplan/01-netcfg.yaml

	else

		echo ''
		read -p 'Use IPV4 DHCP ( yes or no ) : ' ipv4DHCPChoice
		echo ''
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

	echo ''
	echo 'File 01-netcfg.yaml was created in /etc/netplan/'

}

function networkApply {

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
	if [ "$ipv4" == 1 && "$ipv6" == 1 ]; then
		echo "Interface $interface is know configured on $ipv4Adress or $ipv6Adress"
	else [ "$ipv4" == 1 ]; then
		echo "Interface $interface is know configured on $ipv4Adress"
	else [ "$ipv6" == 1 ]; then
    	echo "Interface $interface is know configured on $ipv6Adress"
	fi
	echo "The gateway is $gateway"

}

echo '######## CONFIG NETWORK ########'
echo ''
networkCreateConf
echo ''
networkApply
echo ''