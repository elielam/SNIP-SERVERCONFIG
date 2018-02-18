#!/bin/bash
echo '######## CONFIG WEBSERVER ########'

echo ''

echo 'INSTALL APACHE2'

echo ''

sudo apt-get install apache2 -y

echo ''

echo 'INSTALL PHP'

echo ''

sudo apt-get install php -y

echo ''

sudo apt-get install php-xml -y

echo ''

echo 'ALLOW UFW'

echo ''

sudo ufw allow 'Apache Full'

echo ''

echo 'MOD SECURITY'

echo ''

sudo apt-get install libapache2-modsecurity -y

echo ''

echo "RESTART APACHE2"

echo ''

sudo systemctl restart apache2

echo ''

echo "BLOCK DDOS W/ MOD-EVASIVE"

echo ''

sudo apt-get install libapache2-mod-evasive -y

echo ''

echo 'CONFIG MOD-EVASIVE'

echo ''

{
	echo '<IfModule mod_evasive20.c>'
    echo '	 DOSHashTableSize    3097'
    echo '	 DOSPageCount        2'
    echo '	 DOSSiteCount        50'
    echo '	 DOSPageInterval     1'
    echo ' 	 DOSSiteInterval     1'
    echo '	 DOSBlockingPeriod   10'

    echo '	 DOSEmailNotify      you@yourdomain.com'
    echo '	 DOSSystemCommand    "su - someuser -c '/sbin/... %s ...'"'
    echo '	 DOSLogDir           "/var/log/mod_evasive"'
	echo '</IfModule>'
} >/etc/apache2/mods-enabled/evasive.conf

echo 'File /etc/apache2/mods-enabled/evasive.conf was created !'

echo ''

echo 'CONFIG MOD-EVASIVE LOG'

echo ''

sudo rm -rf /var/log/mod_evasive

sudo mkdir /var/log/mod_evasive

echo 'Directory /var/log/mod_evasive was created !'

sudo chown -R www-data:www-data /var/log/mod_evasive

echo ''

echo "RESTART APACHE2"

echo ''

sudo systemctl restart apache2

echo ''

read -p 'Would you want to deploy your app ? ( y or n ) : ' choice

echo ''

case "$choice" in
"y" | "Y")

    echo 'DEPLOYMENT TOOL'

    read -p 'Install COMPOSER ? ( y or n ) : ' composerchoice

    case "$composerchoice" in
    "y" | "Y")
        echo ''
        sudo apt-get install composer -y
        echo ''
    ;;
    esac

    read -p 'Install NODEJS ? ( y or n ) : ' nodechoice

    case "$nodechoice" in
    "y" | "Y")
        echo ''
        sudo apt-get install nodejs -y
        echo ''
        read -p 'Install NPM ? ( y or n ) : ' npmchoice

        case "$npmchoice" in
        "y" | "Y")
            echo ''
            sudo apt-get install npm -y
            echo ''
        ;;
        esac

        read -p 'Install YARN ? ( y or n ) : ' yarnchoice

        case "$yarnchoice" in
        "y" | "Y")
            echo ''
            curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
            echo ''
            echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
            echo ''
            sudo apt-get update -y
            echo ''
            sudo apt-get install yarn -y
            echo ''
        ;;
        esac
    ;;
    esac

    echo 'CONFIG DOMAIN'

    echo ''

	sudo rm -rf /var/www/html

   	read -p 'Name your domain ( name.lang : app.com ) : ' domainName

	sudo mkdir /var/www/$domainName

	echo ''

    read -p 'Clone from git ? ( y or n ) : ' gitchoice

    case "$gitchoice" in
    "y" | "Y")
        echo ''
        read -p 'Enter repository name ? ( myrepository.git ) :' gitrepo
        sudo git clone https://github.com/elielam/$gitrepo /var/www/$domainName/public_html
    ;;
    "n" | "N")
        sudo mkdir /var/www/$domainName/public_html
        {
            echo '<?php phpinfo(); ?>'
        } >/var/www/$domainName/public_html/index.php
    ;;
    esac

    #VIRTUALHOST CONFIG

    sudo rm /etc/apache2/sites-available/000-default.conf

    {
        echo ' '
    } >/etc/apache2/sites-available/000-default.conf
    
    {
        echo "<VirtualHost *:80>"
        echo "    ServerName www.$domainName"
        echo "    ServerAdmin supervisor@$domainName"
        echo "    DocumentRoot /var/www/$domainName/public_html"
        echo "    ErrorLog /var/log/apache2/$domainName.error.log"
        echo "    CustomLog /var/log/apache2/domainName.access.log combined"
        echo "    LogLevel warn"
        echo "</VirtualHost>"
    } >/etc/apache2/sites-available/$domainName.conf

    echo 'VirtualHost file was created in /etc/apache2/sites-available/ !'

    echo ''

    sudo a2ensite $domainName.conf

    echo 'Apache Server is install and up-to-date'
    echo ''
    echo 'PHP VERSION'
    echo ''
    php -v
    echo ''
    echo "Go to /var/www/$domainName/public_html and deploy your app"
    ;;

"n" | "N")

	sudo rm /var/www/html/index.html
	{
		echo '<?php phpinfo(); ?>'
	} >/var/www/html/index.php

    echo 'Apache Server is install and up-to-date'
    echo ''
    echo 'PHP VERSION'
    echo ''
    php -v
    echo ''
    echo 'Go to /var/www/html/ and deploy your app'
    ;;

*)
    echo 'Confirm with y or n , try again'
    ;;
esac

echo ''

echo "RESTART APACHE2"

echo ''

sudo systemctl restart apache2

echo 'Apache2 was restarted !'

echo ''











