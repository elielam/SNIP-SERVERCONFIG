#!/bin/bash

webserver=
php=
deploy=

if [[ $1 == "ws" ]] || [[ $2 == "ws" ]] || [[ $3 == "ws" ]]; then
    webserver=1
fi

if [[ $1 == "php" ]] || [[ $2 == "php" ]] || [[ $3 == "php" ]]; then
    php=1
fi

if [[ $1 == "d" ]] || [[ $2 == "d" ]] || [[ $3 == "d" ]]; then
    deploy=1
fi

if [[ $1 == "h" ]]; then
    echo
    echo "Config Web Server" 
    echo 
    echo "options:" 
    echo "ws                Install Web server" 
    echo "php               Install PHP and give you choice to install some tools"
    echo "d                 Deploy first app from git elielam,"
    echo 
    echo "exemple : ./script.sh d t" 
    echo
    exit 0
fi

function webServerInstall {
    if [[ $webserver == 1 ]]; then
        read -p 'What server do you want to install ? ( apache , nginx , lighttpd , tomcat , node ) : ' webServerType
        echo

        case "$webServerType" in
            "apache" )
                echo 'INSTALL APACHE2 SERVER'
                echo
                sudo apt-get install apache2 -y
                echo
                webServerApacheSecurity
                echo
                read -p 'Create virtualHost on apache server ? ( y or n ) : ' vHostChoice
                echo
                if [[ $vHostChoice == "y" ]] || [[ $vHostChoice == "Y" ]]; then
                    apacheServerVHOST
                else
                    sudo rm /var/www/html/index.html
                    {
                        echo '<?php phpinfo(); ?>'
                    } >/var/www/html/index.php
                fi
                ;;
            "nginx" )
                echo 'INSTALL NGINX SERVER'
                echo 'This feature will be available soon'
                ;;
            "lighttpd" )
                echo 'INSTALL LIGHTTPD SERVER'
                echo 'This feature will be available soon'
                ;;
            "tomcat" )
                echo 'INSTALL TOMCAT SERVER'
                echo 'This feature will be available soon'
                ;;
            "node" )
                echo 'INSTALL NODE SERVER'
                echo 'This feature will be available soon'
                ;;
        esac
    fi
}

function apacheServerSecurity {
    echo 'INSTALL MOD SECURITY'
    echo
    sudo apt-get install libapache2-modsecurity -y
    echo
    echo "INSTALL MOD-EVASIVE"
    echo
    sudo apt-get install libapache2-mod-evasive -y
    echo
    echo 'CONFIG MOD-EVASIVE'
    echo

    {
        echo '<IfModule mod_evasive20.c>'
        echo '   DOSHashTableSize    3097'
        echo '   DOSPageCount        2'
        echo '   DOSSiteCount        50'
        echo '   DOSPageInterval     1'
        echo '   DOSSiteInterval     1'
        echo '   DOSBlockingPeriod   10'

        echo '   DOSEmailNotify      you@yourdomain.com'
        echo '   DOSSystemCommand    "su - someuser -c '/sbin/... %s ...'"'
        echo '   DOSLogDir           "/var/log/mod_evasive"'
        echo '</IfModule>'
    } >/etc/apache2/mods-enabled/evasive.conf

    echo 'File /etc/apache2/mods-enabled/evasive.conf was created !'
    echo
    echo 'CONFIG MOD-EVASIVE LOG'
    echo
    sudo rm -rf /var/log/mod_evasive
    sudo mkdir /var/log/mod_evasive
    sudo chown -R www-data:www-data /var/log/mod_evasive
    echo 'Directory /var/log/mod_evasive was created and assign owner to www-data !'
}

function apacheServerVHOST {
    echo 'CONFIG DOMAIN'
    echo
    sudo rm -rf /var/www/html
    read -p 'Name your domain ( name.lang : app.com ) : ' domainName
    sudo mkdir /var/www/$domainName/public_html
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

    if [[ $deploy != 1 ]]; then
        {
            echo '<?php phpinfo(); ?>'
        } >/var/www/$domainName/public_html/index.php
    fi

    echo 'VirtualHost file was created in /etc/apache2/sites-available/ !'
    echo
    sudo a2ensite $domainName.conf
    echo "Apache vHost is install on www.$domainName"
}

function restartApacheServer {
    echo "RESTART APACHE2"
    echo
    sudo systemctl restart apache2
    echo 'Web Server is install and up-to-date'
    echo
    echo 'PHP VERSION'
    echo
    php -v
}

function webPHPInstall {
    if [[ $php == 1 ]]; then

        echo 'INSTALL PHP LAST VERSION'
        echo
        sudo apt-get install php -y
        echo

        echo 'INSTALL PHP-TOOLS'
        echo
        sudo apt-get install php-xml -y

        echo 'INSTALL DEPLOYMENT TOOL'
        read -p 'Install COMPOSER ? ( y or n ) : ' composerchoice

        case "$composerchoice" in
        "y" | "Y")
            echo
            sudo apt-get install composer -y
        ;;
        esac

        echo
        read -p 'Install NODEJS ? ( y or n ) : ' nodechoice

        case "$nodechoice" in
        "y" | "Y")
            echo
            sudo apt-get install nodejs -y
            echo
            read -p 'Install NPM ? ( y or n ) : ' npmchoice

            case "$npmchoice" in
            "y" | "Y")
                echo
                sudo apt-get install npm -y
            ;;
            esac

            echo

            read -p 'Install YARN ? ( y or n ) : ' yarnchoice

            case "$yarnchoice" in
            "y" | "Y")
                echo
                curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
                echo
                echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
                echo
                sudo apt-get update -y
                echo
                sudo apt-get install yarn -y
            ;;
            esac
        ;;
        esac

    fi  
}

function webDeployApp {
    if [[ $deploy == 1 ]]; then
        sudo rm -rf /var/www/$domainName/public_html
        read -p 'Enter repository name ? ( myrepository.git ) :' gitrepo
        sudo git clone https://github.com/elielam/$gitrepo /var/www/$domainName/public_html
    fi
    
}

echo
echo '######## CONFIG WEBSERVER ########'
echo
webServerInstall
echo
webPHPInstall
echo
webDeployApp
echo
restartApacheServer
echo

unset webserver
unset php
unset deploy
unset webServerType
unset vHostChoice
unset domainName
unset deploy
unset composerchoice
unset nodechoice
unset npmchoice
unset yarnchoice