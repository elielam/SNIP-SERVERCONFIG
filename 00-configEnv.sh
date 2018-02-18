#!/bin/bash
echo '######## ENV BASICS ########'

echo 'UPDATE'

echo ''

sudo apt-get update -y

echo ''

echo 'UPGRADE'

echo ''

sudo apt-get upgrade -y

echo ''

echo 'DIST-UPGRADE'

echo ''

read -p 'Would you want to dist-upgrade ( y or n ) : ' choice

echo ''

case "$choice" in
"y" | "Y")
    sudo apt-get dist-upgrade -y
    echo ''
    echo 'Env is up-to-date'
    ;;
"n" | "N")
    echo 'Env is update and upgrade'
    ;;
*)
    echo 'Confirm with y or n , try again'
    ;;
esac

echo ''
