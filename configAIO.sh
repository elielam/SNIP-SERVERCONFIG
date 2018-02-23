#!/bin/bash

function env_aio {

    echo '+-----------------------------------+'
    echo '|          ENVIRONNEMENT            |'
    echo '+-----------------------------------+'
    echo
    echo

    echo '#### UPDATE ####'
	echo
	sudo apt-get update -y
    echo
    echo '#### UPGRADE ####'
	echo
	sudo apt-get upgrade -y
	echo

    read -ep 'Would you want to install some basic tools ? ( yes or no ): ' -i 'yes' isTools
    echo

    if [[ "$isTools" == 'yes'  ]] || [[ "$isTools" == 'y'  ]] || [[ "$isTools" == 'YES'  ]] || [[ "$isTools" == 'Y'  ]]; then

        echo '#### INSTALL BASICS TOOLS ####'
        echo
        sudo apt-get install zip unzip -y
        echo

        read -ep "Install Ubuntu Desktop for graphical ENV ? ( yes or no ): " isUbuntuDesktop
        echo

        if [[ "$isUbuntuDesktop" == 'yes'  ]] || [[ "$isUbuntuDesktop" == 'y'  ]] || [[ "$isUbuntuDesktop" == 'YES'  ]] || [[ "$isUbuntuDesktop" == 'Y'  ]]; then

            sudo apt-get install ubuntu-desktop -y
            echo
            echo 'You will need to restart system for use Ubuntu Desktop , please run : sudo shutdown -r now , to restart system !'

        fi

    fi

	read -ep 'Would you want to dist-upgrade ? ( yes or no ): ' -i 'yes' isDistUpgrade
	echo

	if [[ "$isDistUpgrade" == 'yes'  ]] || [[ "$isDistUpgrade" == 'y'  ]] || [[ "$isDistUpgrade" == 'YES'  ]] || [[ "$isDistUpgrade" == 'Y'  ]]; then

        echo '#### DIST-UPGRADE ####'
        echo
        sudo apt-get dist-upgrade -y
        echo
        echo 'Your apps are update and upgrade !'
        echo 'Env is up-to-date !'
        echo

    else

        echo 'Your apps are update and upgrade !'
        echo

    fi

}

 #==========================================================================================================================================================================================#

function network_aio {

    echo '+-----------------------------------+'
    echo '|             NETWORK               |'
    echo '+-----------------------------------+'
    echo
    echo

    echo '#### NETPLAN CONFIG ####'
    echo

    read -ep 'Would you want to use DHCP configuration ? ( yes or no ): ' -i 'yes' isDHCP
    echo

    if [[ "$isDHCP" == 'yes'  ]] || [[ "$isDHCP" == 'y'  ]] || [[ "$isDHCP" == 'YES'  ]] || [[ "$isDHCP" == 'Y'  ]]; then

        while true; do
            echo " Choose DHCP type you want to configure: "
            echo
            echo "  [1] IPV4"
            echo "  [2] IPV6"
            echo "  [3] BOTH"
            echo

            read -p " please enter your preference: [1|2|3]: " dhcpType
            echo

            case $dhcpType in
                [1]* )
                    dhcpTypeIpv4='yes'
                    dhcpTypeIpv6='no'
                    break;;
                [2]* )
                    dhcpTypeIpv4='no'
                    dhcpTypeIpv6='yes'
                    echo
                    break;;
                [3]* )
                    dhcpTypeIpv4='yes'
                    dhcpTypeIpv6='yes'
                    break;;
                * ) echo " please answer [1], [2] or [3]";;
            esac
        done

        read -ep " Please enter interface you would configure: " interface
        echo

    else

        while true; do
            echo " Choose ADDRESS type you want to configure: "
            echo
            echo "  [1] IPV4"
            echo "  [2] IPV6"
            echo "  [3] BOTH"
            echo

            read -p " please enter your preference: [1|2|3]: " adressType
            echo

            case $adressType in
                [1]* )
                    read -ep " Please enter IPV4 address you would use: " adressTypeIpv4
                    echo
                    break;;
                [2]* )
                    read -ep " Please enter IPV6 address you would use: " adressTypeIpv6
                    echo
                    break;;
                [3]* )
                    read -ep " Please enter IPV4 address you would use: " adressTypeIpv4
                    echo
                    read -ep " Please enter IPV6 address you would use: " adressTypeIpv6
                    echo
                    break;;
                * ) echo " please answer [1], [2] or [3]";;
            esac
        done

        read -ep " Please enter interface you would configure: " interface
        echo

        sudo route -n
        echo

        read -ep " Please enter your gateway: " gateway
        echo

    fi

    {
    	    	echo '# This file describes the network interfaces available on your system'
    			echo '# For more information, see netplan(5).'
    			echo 'network:'
    			echo ' version: 2'
    			echo ' renderer: networkd'
    			echo ' ethernets:'
    			echo "   $interface:"

    			if [[ "$isDHCP" == 'yes'  ]] || [[ "$isDHCP" == 'y'  ]] || [[ "$isDHCP" == 'YES'  ]] || [[ "$isDHCP" == 'Y'  ]]; then

                    echo "     dhcp4: $dhcpTypeIpv4"
                    echo "     dhcp6: $dhcpTypeIpv6"

    			else

    			    echo '     dhcp4: no'
                    echo '     dhcp6: no'

                    if [[ $adressType == 1 ]]; then
                        echo "     addresses: [$adressTypeIpv4/24]"
                    elif [[ $adressType == 2 ]]; then
                        echo "     addresses: [$adressTypeIpv6/64]"
                    elif [[ $adressType == 3 ]]; then
                        echo "     addresses: [$adressTypeIpv4/24, '$adressTypeIpv6/64']"
                    fi

                    echo "     gateway4: $gateway"
                    echo '     nameservers:'
                    echo '       addresses: [8.8.8.8,8.8.4.4]'

    			fi
    		} >/etc/netplan/01-netcfg.yaml

    		echo 'File /etc/netplan/01-netcfg.yaml was created !'
            echo

            echo '#### NETPLAN DEBUG ####'
            echo
            sudo netplan --debug generate
            echo

            echo '#### NETPLAN APPLY ####'
            echo
            sudo netplan apply
            echo

            echo '#### CONFIG FINISHED ####'
            echo

            if [[ $adressType == 1 ]]; then
                echo "Interface $interface is know configured on $ipv4Adress"
            elif [[ $adressType == 2 ]]; then
                echo "Interface $interface is know configured on $ipv6Adress"
            elif [[ $adressType == 3 ]]; then
                echo "Interface $interface is know configured on $ipv4Adress or $ipv6Adress"
            fi
            echo "The gateway is $gateway"
            echo

}

 #==========================================================================================================================================================================================#

function ssh_aio {

    echo '+-----------------------------------+'
    echo '|               SSH                 |'
    echo '+-----------------------------------+'
    echo
    echo

    echo '#### INSTALL SSH ####'
    echo
    sudo apt-get install openssh-server -y
    echo

    echo '#### SSH CONFIG ####'
    echo

    read -ep 'Enter SSH PORT: ' -i 22 sshport
    echo

    read -ep 'Allow root ? ( yes or no ): ' -i 'no' isAllowRoot
    echo

    read -ep 'Do you want to restrict access to specific users ? ( yes or no ): ' -i 'yes' isAllowUser
    echo

    if [[ "$isAllowUser" == 'yes'  ]] || [[ "$isAllowUser" == 'y'  ]] || [[ "$isAllowUser" == 'YES'  ]] || [[ "$isAllowUser" == 'Y'  ]]; then
    read -ep 'How user.s do you want to allow ? ( user1 user2 user3 ): ' allowUsers
    echo
    fi

    read -ep 'Max authentification try ?: -i 5 ' maxAuthTry
    echo

    read -ep 'Max ssh sessions ?: ' -i 5 maxSession
    echo

    {
    		echo '#	$OpenBSD: sshd_config,v 1.101 2017/03/14 07:19:07 djm Exp $'
    		echo
    		echo '# This is the sshd server system-wide configuration file.  See'
    		echo '# sshd_config(5) for more information.'
    		echo
    		echo '# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin'
    		echo
    		echo '# The strategy used for options in the default sshd_config shipped with'
    		echo '# OpenSSH is to specify options with their default value where'
    		echo '# possible, but leave them commented.  Uncommented options override the'
    		echo '# default value.'
    		echo
    		echo "Port $sshport"
    		echo '#AddressFamily any'
    		echo '#ListenAddress 0.0.0.0'
    		echo '#ListenAddress ::'
    		echo
    		echo '#HostKey /etc/ssh/ssh_host_rsa_key'
    		echo '#HostKey /etc/ssh/ssh_host_ecdsa_key'
    		echo '#HostKey /etc/ssh/ssh_host_ed25519_key'
    		echo
    		echo '# Ciphers and keying'
    		echo '#RekeyLimit default none'
    		echo
    		echo '# Logging'
    		echo 'SyslogFacility AUTH'
    		echo 'LogLevel INFO'
            if [[ "$isAllowUser" == 'yes'  ]] || [[ "$isAllowUser" == 'y'  ]] || [[ "$isAllowUser" == 'YES'  ]] || [[ "$isAllowUser" == 'Y'  ]]; then
                if [[ "$isAllowRoot" == 'yes'  ]] || [[ "$isAllowRoot" == 'y'  ]] || [[ "$isAllowRoot" == 'YES'  ]] || [[ "$isAllowRoot" == 'Y'  ]]; then
    		    echo "AllowUsers root $allowUsers"
    		    else
    		    echo "AllowUsers $allowUsers"
    		    fi
    		fi
    		echo
    		echo '# Authentication:'
    		echo
    		echo 'LoginGraceTime 2m'
    		echo "PermitRootLogin $isAllowRoot"
    		echo '#StrictModes yes'
    		echo "MaxAuthTries $maxAuthTry"
    		echo "MaxSessions $maxSession"
    		echo
    		echo '#PubkeyAuthentication yes'
    		echo
    		echo '# Expect .ssh/authorized_keys2 to be disregarded by default in future.'
    		echo '#AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2'
    		echo
    		echo '#AuthorizedPrincipalsFile none'
    		echo
    		echo '#AuthorizedKeysCommand none'
    		echo '#AuthorizedKeysCommandUser nobody'
    		echo
    		echo '# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts'
    		echo '#HostbasedAuthentication no'
    		echo "# Change to yes if you don't trust ~/.ssh/known_hosts for"
    		echo '# HostbasedAuthentication'
    		echo '#IgnoreUserKnownHosts no'
    		echo "# Don't read the user's ~/.rhosts and ~/.shosts files"
    		echo '#IgnoreRhosts yes'
    		echo
    		echo '# To disable tunneled clear text passwords, change to no here!'
    		echo 'PasswordAuthentication yes'
    		echo '#PermitEmptyPasswords no'
    		echo
    		echo '# Change to yes to enable challenge-response passwords (beware issues with'
    		echo '# some PAM modules and threads)'
    		echo 'ChallengeResponseAuthentication no'
    		echo
    		echo '# Kerberos options'
    		echo '#KerberosAuthentication no'
    		echo '#KerberosOrLocalPasswd yes'
    		echo '#KerberosTicketCleanup yes'
    		echo '#KerberosGetAFSToken no'
    		echo
    		echo '# GSSAPI options'
    		echo '#GSSAPIAuthentication no'
    		echo '#GSSAPICleanupCredentials yes'
    		echo '#GSSAPIStrictAcceptorCheck yes'
    		echo '#GSSAPIKeyExchange no'
    		echo
    		echo "# Set this to 'yes' to enable PAM authentication, account processing,"
    		echo '# and session processing. If this is enabled, PAM authentication will'
    		echo '# be allowed through the ChallengeResponseAuthentication and'
    		echo '# PasswordAuthentication.  Depending on your PAM configuration,'
    		echo '# PAM authentication via ChallengeResponseAuthentication may bypass'
    		echo '# the setting of "PermitRootLogin without-password".'
    		echo '# If you just want the PAM account and session checks to run without'
    		echo '# PAM authentication, then enable this but set PasswordAuthentication'
    		echo "# and ChallengeResponseAuthentication to 'no'."
    		echo 'UsePAM no'
    		echo
    		echo '#AllowAgentForwarding yes'
    		echo '#AllowTcpForwarding yes'
    		echo '#GatewayPorts no'
    		echo 'X11Forwarding yes'
    		echo '#X11DisplayOffset 10'
    		echo '#X11UseLocalhost yes'
    		echo '#PermitTTY yes'
    		echo 'PrintMotd no'
    		echo '#PrintLastLog yes'
    		echo '#TCPKeepAlive yes'
    		echo '#UseLogin no'
    		echo '#PermitUserEnvironment no'
    		echo '#Compression delayed'
    		echo '#ClientAliveInterval 0'
    		echo '#ClientAliveCountMax 3'
    		echo '#UseDNS no'
    		echo '#PidFile /var/run/sshd.pid'
    		echo '#MaxStartups 10:30:100'
    		echo '#PermitTunnel no'
    		echo '#ChrootDirectory none'
    		echo '#VersionAddendum none'
    		echo
    		echo '# no default banner path'
    		echo '#Banner none'
    		echo
    		echo '# Allow client to pass locale environment variables'
    		echo 'AcceptEnv LANG LC_*'
    		echo
    		echo '# override default of no subsystems'
    		echo 'Subsystem	sftp	/usr/lib/openssh/sftp-server'
    		echo
    		echo '# Example of overriding settings on a per-user basis'
    		echo '#Match User anoncvs'
    		echo '#	X11Forwarding no'
    		echo '#	AllowTcpForwarding no'
    		echo '#	PermitTTY no'
    		echo '#	ForceCommand cvs server'
    	} >/etc/ssh/sshd_config

    echo 'File /etc/ssh/sshd_config was created !'
    echo

    echo '#### SSH APPLY ####'
    echo

    sudo /etc/init.d/ssh restart
    echo

    echo '#### CONFIG FINISHED ####'
    echo

    # Modify in future to test if its ipv4 or ipv6 or both and display appropriate message
    echo "Service SSH is know configured on port $sshport"
    if [[ "$isAllowUser" == 'yes'  ]] || [[ "$isAllowUser" == 'y'  ]] || [[ "$isAllowUser" == 'YES'  ]] || [[ "$isAllowUser" == 'Y'  ]]; then
        if [[ "$isAllowRoot" == 'yes'  ]] || [[ "$isAllowRoot" == 'y'  ]] || [[ "$isAllowRoot" == 'YES'  ]] || [[ "$isAllowRoot" == 'Y'  ]]; then
        echo "You can know connect through ssh with user root or $allowUsers"
        else
        echo "You can know connect through ssh with user $allowUsers"
        fi
    fi

}

echo
echo 'Start process ...'
echo
env_aio
echo
network_aio
echo
ssh_aio
echo
echo 'End process ...'
echo