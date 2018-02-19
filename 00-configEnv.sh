#!/bin/bash
dist=

while getopts "iqcv:tb:" OPTION
do
    case $OPTION in
        d)
            dist=1
            ;;
        \?)
            echo "Config Environnment tool" 
            echo " " 
            echo "options:" 
            echo "-d                Perform dist-upgrade" 
            echo " " 
            echo "exemple : ./deploy.sh -v=2.1.2 -c -n" 
            exit 0
            ;;
    esac
done

echo '######## ENV BASICS ########'

echo 'UPDATE'

echo ''

sudo apt-get update -y

echo ''

echo 'UPGRADE'

echo ''

sudo apt-get upgrade -y

echo ''

echo 'TOOLS'

echo ''

echo 'ZIP - UNZIP TOOLS'

echo ''

sudo apt-get install zip unzip -y

echo ''

echo 'DIST-UPGRADE'

echo ''

read -p 'Would you want to dist-upgrade ( y or n ) : ' choice

echo ''

if [ "$dist" == 1  ]; then
	sudo apt-get dist-upgrade -y
	echo ''
    echo 'Env is up-to-date'
    echo ''
fi


    
    

