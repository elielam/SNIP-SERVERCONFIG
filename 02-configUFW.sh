#!/bin/bash
echo '######## CONFIG UFW ########'
echo ''
echo 'BLOCK ALL ENTRY'
echo ''

sudo ufw default deny incoming
sudo ufw default allow outgoing

echo ''

sudo ufw enable

echo ''

sudo ufw status verbose