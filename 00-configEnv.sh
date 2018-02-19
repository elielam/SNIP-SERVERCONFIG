#!/bin/bash

dist=
tools=

while getopts "iqcv:tb:" OPTION
do
    case $OPTION in
    	t)
			tools=1
			;;
        d)
            dist=1
            ;;
        \?)
            echo "Config Environnment tool" 
            echo " " 
            echo "options:" 
            echo "-d                Perform dist-upgrade" 
            echo "-t                Perform some tools install"
            echo "					ZIP,UNZIP," 
            echo " " 
            echo "exemple : ./script.sh -d -t" 
            exit 0
            ;;
    esac
done

function env_update {
	echo 'UPDATE'
	echo ''
	sudo apt-get update -y
}

function env_upgrade {
	echo 'UPGRADE'
	echo ''
	sudo apt-get upgrade -y
}

function env_dist_upgrade {
	if [ "$dist" == 1  ]; then
		echo 'DIST-UPGRADE'
		sudo apt-get dist-upgrade -y
		echo ''
	    echo 'Env is up-to-date !'
    else
    	echo 'Your apps are update and upgrade !'
	fi
}

function env_tools {
	if [ "$dist" == 1  ]; then
		echo 'INSTALL TOOLS'
		echo ''
		sudo apt-get install zip unzip -y
        echo ''
        read -p "Install Ubuntu Desktop for graphical ENV ? ( y or n ) : " ubuntuDesktopChoice
        echo ''
        if [[ "$ubuntuDesktopChoice" = "y" | "$ubuntuDesktopChoice" = "Y" ]]; then
            sudo apt-get install ubuntu-desktop
            echo ''
            echo 'You will need to restart system for use Ubuntu Desktop , please run : sudo shutdown -r now , to restart system !'
        fi
    fi
}

echo '######## ENV BASICS ########'
echo ''
env_update
echo ''
env_upgrade
echo ''
env_tools
echo ''
env_dist_upgrade
echo ''



    
    

