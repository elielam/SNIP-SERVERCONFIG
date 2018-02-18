
<h2> Scripts for deploy web server on UBUNTU 17.10 </h2>

- 00 - ENV

Do clean update , upgrade and if you want dist-upgrade.

- 01 - NETWORK

Provide possibility to configure static ipv4 or ipv6.

- 02 - UFW

Deny all connection and add ssh and apache in allowed rules.

- 03 - SSH

Install and configure SSH service provide user the choice of ssh port and alowUsers.

#Provide sshd_config snippet

- 04 - WEBSERVER

Install apache2 and last PHP version with some utils.
Permit to simply deploy your app with vHost creation and git deployement,
with some tools choice like COMPOSER or NODEJS.

- HOW TO USE 

	  sudo sh 0x-xxxxxx.sh

Run them in order , it's primary !

---------------------------------------------------------------

IF ERROR

TRY :

	sudo chmod 755 0x-xxxxxx.sh

	sudo vi 0x-xxxxxx.sh
	escape key
		:set formatfile=unix
		:x!

launch again 
