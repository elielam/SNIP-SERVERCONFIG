#!/bin/bash
echo '######## CONFIG UFW ########'
echo ''
echo 'BLOCK ALL ENTRY'
echo ''

sudo ufw default deny incoming
sudo ufw default allow outgoing

echo ''

echo 'ALLOW SSH'

echo ''

sudo ufw allow ssh

echo ''

echo 'ALLOW APACHE2'

echo ''

sudo ufw allow 'Apache Full'

echo ''

sudo ufw enable

echo ''

sudo ufw status verbose