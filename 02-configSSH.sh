#!/bin/bash
echo '######## CONFIG SSH ########'
echo ''
echo 'UPDATE'

echo ''

sudo apt-get update -y

echo ''

echo 'INSTALL SSH'

echo ''

sudo apt-get install openssh-server -y

echo ''

read -p 'Enter SSH PORT : ' sshport

echo ''

read -p 'How user.s do you want to allow ( user1 user2 user3 ) : ' alowusers

echo ''

	{
		echo '#	$OpenBSD: sshd_config,v 1.101 2017/03/14 07:19:07 djm Exp $'
		echo ''
		echo '# This is the sshd server system-wide configuration file.  See'
		echo '# sshd_config(5) for more information.'
		echo ''
		echo '# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin'
		echo ''
		echo '# The strategy used for options in the default sshd_config shipped with'
		echo '# OpenSSH is to specify options with their default value where'
		echo '# possible, but leave them commented.  Uncommented options override the'
		echo '# default value.'
		echo ''
		echo "Port $sshport"
		echo '#AddressFamily any'
		echo '#ListenAddress 0.0.0.0'
		echo '#ListenAddress ::'
		echo ''
		echo '#HostKey /etc/ssh/ssh_host_rsa_key'
		echo '#HostKey /etc/ssh/ssh_host_ecdsa_key'
		echo '#HostKey /etc/ssh/ssh_host_ed25519_key'
		echo ''
		echo '# Ciphers and keying'
		echo '#RekeyLimit default none'
		echo ''
		echo '# Logging'
		echo 'SyslogFacility AUTH'
		echo 'LogLevel INFO'
		echo "AllowUsers $alowusers"
		echo ''
		echo '# Authentication:'
		echo ''
		echo 'LoginGraceTime 2m'
		echo 'PermitRootLogin yes'
		echo '#StrictModes yes'
		echo 'MaxAuthTries 5'
		echo 'MaxSessions 5'
		echo ''
		echo '#PubkeyAuthentication yes'
		echo ''
		echo '# Expect .ssh/authorized_keys2 to be disregarded by default in future.'
		echo '#AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2'
		echo ''
		echo '#AuthorizedPrincipalsFile none'
		echo ''
		echo '#AuthorizedKeysCommand none'
		echo '#AuthorizedKeysCommandUser nobody'
		echo ''
		echo '# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts'
		echo '#HostbasedAuthentication no'
		echo "# Change to yes if you don't trust ~/.ssh/known_hosts for"
		echo '# HostbasedAuthentication'
		echo '#IgnoreUserKnownHosts no'
		echo "# Don't read the user's ~/.rhosts and ~/.shosts files"
		echo '#IgnoreRhosts yes'
		echo ''
		echo '# To disable tunneled clear text passwords, change to no here!'
		echo 'PasswordAuthentication yes'
		echo '#PermitEmptyPasswords no'
		echo ''
		echo '# Change to yes to enable challenge-response passwords (beware issues with'
		echo '# some PAM modules and threads)'
		echo 'ChallengeResponseAuthentication no'
		echo ''
		echo '# Kerberos options'
		echo '#KerberosAuthentication no'
		echo '#KerberosOrLocalPasswd yes'
		echo '#KerberosTicketCleanup yes'
		echo '#KerberosGetAFSToken no'
		echo ''
		echo '# GSSAPI options'
		echo '#GSSAPIAuthentication no'
		echo '#GSSAPICleanupCredentials yes'
		echo '#GSSAPIStrictAcceptorCheck yes'
		echo '#GSSAPIKeyExchange no'
		echo ''
		echo "# Set this to 'yes' to enable PAM authentication, account processing,"
		echo '# and session processing. If this is enabled, PAM authentication will'
		echo '# be allowed through the ChallengeResponseAuthentication and'
		echo '# PasswordAuthentication.  Depending on your PAM configuration,'
		echo '# PAM authentication via ChallengeResponseAuthentication may bypass'
		echo '# the setting of "PermitRootLogin without-password".'
		echo '# If you just want the PAM account and session checks to run without'
		echo '# PAM authentication, then enable this but set PasswordAuthentication'
		echo "# and ChallengeResponseAuthentication to 'no'."
		echo 'UsePAM yes'
		echo ''
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
		echo ''
		echo '# no default banner path'
		echo '#Banner none'
		echo ''
		echo '# Allow client to pass locale environment variables'
		echo 'AcceptEnv LANG LC_*'
		echo ''
		echo '# override default of no subsystems'
		echo 'Subsystem	sftp	/usr/lib/openssh/sftp-server'
		echo ''
		echo '# Example of overriding settings on a per-user basis'
		echo '#Match User anoncvs'
		echo '#	X11Forwarding no'
		echo '#	AllowTcpForwarding no'
		echo '#	PermitTTY no'
		echo '#	ForceCommand cvs server'
	} >/etc/ssh/sshd_config

echo 'File sshd_config was created in /etc/ssh/'

echo ''

echo 'SSH APPLY'
echo ''
sudo /etc/init.d/ssh restart

echo ''

echo 'CONFIG FINISHED'
echo ''

# Modify in future to test if its ipv4 or ipv6 or both and display appropriate message
echo "Service SSH is know configured on port $sshport"
echo "You can know connect through ssh with user $alowusers"

echo ''
