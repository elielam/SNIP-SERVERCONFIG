#!/bin/bash

dist=
tools=

if [ $1 = "t" ]; then
	tools=1
elif [ $2 = "t" ]; then
	tools=1
else
	tools=0
fi

if [ $1 = "d" ]; then
	dist=1
elif [ $2 = "d" ]; then
	dist=1
else
	dist=0
fi


if [ "$1" = "h" ]; then
	echo "Config Environnment tool" 
    echo " " 
    echo "options:" 
    echo "d                Perform dist-upgrade" 
    echo "t                Perform some tools install"
    echo "					ZIP,UNZIP," 
    echo " " 
    echo "exemple : ./script.sh d t" 
    exit 0
fi

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
        if [[ "$ubuntuDesktopChoice" = "y" || "$ubuntuDesktopChoice" = "Y" ]]; then
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



    
    

