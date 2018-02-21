#!/bin/bash

ipv6=
web=
mail=
ssh=
dhcp=
ftp=
webdb=

if [[ $1 == "ipv6" ]] || [[ $2 == "ipv6" ]] || [[ $3 == "ipv6" ]] || [[ $4 == "ipv6" ]] || [[ $5 == "ipv6" ]] || [[ $6 == "ipv6" ]] || [[ $7 == "ipv6" ]]; then
	ipv6=1
fi

if [[ $1 == "web" ]] || [[ $2 == "web" ]] || [[ $3 == "web" ]] || [[ $4 == "web" ]] || [[ $5 == "web" ]] || [[ $6 == "web" ]] || [[ $7 == "web" ]]; then
	web=1
fi

if [[ $1 == "mail" ]] || [[ $2 == "mail" ]] || [[ $3 == "mail" ]] || [[ $4 == "mail" ]] || [[ $5 == "mail" ]] || [[ $6 == "mail" ]] || [[ $7 == "mail" ]]; then
	mail=1
fi

if [[ $1 == "ssh" ]] || [[ $2 == "ssh" ]] || [[ $3 == "ssh" ]] || [[ $4 == "ssh" ]] || [[ $5 == "ssh" ]] || [[ $6 == "ssh" ]] || [[ $7 == "ssh" ]]; then
	ssh=1
fi

if [[ $1 == "dhcp" ]] || [[ $2 == "dhcp" ]] || [[ $3 == "dhcp" ]] || [[ $4 == "dhcp" ]] || [[ $5 == "dhcp" ]] || [[ $6 == "dhcp" ]] || [[ $7 == "dhcp" ]]; then
	dhcp=1
fi

if [[ $1 == "ftp" ]] || [[ $2 == "ftp" ]] || [[ $3 == "ftp" ]] || [[ $4 == "ftp" ]] || [[ $5 == "ftp" ]] || [[ $6 == "ftp" ]] || [[ $7 == "ftp" ]]; then
	ftp=1
fi

if [[ $1 == "webdb" ]] || [[ $2 == "webdb" ]] || [[ $3 == "webdb" ]] || [[ $4 == "webdb" ]] || [[ $5 == "webdb" ]] || [[ $6 == "webdb" ]] || [[ $7 == "webdb" ]]; then
	webdb=1
fi

if [[ $1 == "h" ]]; then
	echo "Config UFW" 
    echo " " 
    echo "options:" 
    echo "ipv6               Configure ufw with ipv6" 
    echo "w                Web server profile"
    echo "wd               Web database server profile"
    echo "m                Mail server profile" 
    echo "s                SSH server profile" 
    echo "d                DHCP server profile" 
    echo "f                FTP server profile" 
    echo " " 
    echo "exemple : ./script.sh ipv6 w m s f" 
    exit 0
fi

function ifwIPV6 {
	#some code to write in /etc/default/ufw and add or replace IPV6=yes
	if [[ $ipv6 == 1 ]]; then
		echo 'Do some stuff with /etc/default/ufw'
	fi
}

function ufwEssentials {
	echo 'BLOCK ALL ENTRY'
	echo
	sudo ufw default deny incoming
	sudo ufw default deny outgoing
}

function ufwAllowWeb {
	if [[ $web == 1 ]]; then
		echo 'ALLOW WEBSERVER'
		echo
		

		read -p "Enter server type : ( apache , nginx , lighttpd , tomcat , node ) " serverType
		case "$serverType" in
		"apache")
			sudo ufw allow 'Apache Full' comment 'Server Apache'
			;;
		"nginx")
			sudo ufw allow 'Apache Full' comment 'Server NGINX'
			;;
		"lighttpd")
			sudo ufw allow 'Apache Full' comment 'Server LIGHTTPD'
			;;
		"tomcat")
			sudo ufw allow 8080 comment 'Server TOMCAT'
			;;
		"node")
			read -p "Enter NodeServer port : " nodeServerPort
			echo
			sudo ufw allow $nodeServerPort comment 'Server NODE'
			;;
		*)
			echo 'I cant understand , no web server will be allowed in UFW !'
			;;
			esac
	fi
}

function ufwAllowDB {
	if [[ $webdb == 1 ]]; then
		echo 'ALLOW DATABASE'
		echo
		read -p "Enter db type : ( mysql , postgresql , mariadb , oracle ) " dbType
		case "$dbType" in
		"mysql")
			sudo ufw allow 3306 comment 'DB Mysql'
			;;
		"postgresql")
			sudo ufw allow 5432 comment 'DB Postgre'
			;;
		"mariadb")
			sudo ufw allow 3306 comment 'DB Mariadb'
			;;
		"oracle")
			sudo ufw allow 1521 comment 'DB Oracle'
			;;
		*)
			echo 'I cant understand , no db will be allowed in UFW !'
			;;
			esac
	fi
}

function ufwAllowMail {
	if [[ $mail == 1 ]]; then
		echo 'ALLOW MAIL'
		echo
		sudo ufw allow 25 comment 'Mail SMTP'
		# sudo ufw allow 587 #SMTP OUTBOUND
		sudo ufw allow 143 comment 'Mail IMAP'
		sudo ufw allow 993 comment 'Mail IMAPS'
		sudo ufw allow 110 comment 'Mail POP3'
		sudo ufw allow 995 comment 'Mail POP3S'
	fi
}

function ufwAllowSSH {
	if [[ $ssh == 1 ]]; then
		echo 'ALLOW SSH'
		echo
		sudo ufw allow ssh comment 'SSH'
	fi
}

function ufwAllowDHCP {
	if [[ $dhcp == 1 ]]; then
		echo 'ALLOW DHCP'
		echo
		sudo ufw allow 68 comment 'DHCP'
	fi
}

function ufwAllowFTP {
	if [[ $ftp == 1 ]]; then	
		echo 'ALLOW FTP'
		echo
		sudo ufw allow ftp comment 'FTP'
	fi
}

function ufwActivateConf {
	echo 'ENABLE AND STATUS UFW'
	echo
	sudo ufw enable
	echo
	sudo ufw status verbose
}

echo
echo '######## CONFIG UFW ########'
echo 
ufwEssentials
echo 
ufwAllowWeb
echo
ufwAllowDB
echo
ufwAllowMail
echo
ufwAllowSSH
echo
ufwAllowDHCP
echo
ufwAllowFTP
echo
ufwActivateConf
echo

unset ipv6
unset web
unset mail
unset ssh
unset dhcp
unset ftp
unset webdb
unset serverType
unset nodeServerPort
unset dbType
