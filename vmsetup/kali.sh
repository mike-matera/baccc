#!/bin/bash
#This script will prepare a Cloud VM (Digital Ocean) into a Kali Machine accessible via RDP.
#Assuming you are Root:

apt update
apt install dirmngr -y
echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 7D8D0BF6
apt update && apt dist-upgrade -y
apt install kali-linux-default -y
apt install apache2
systemctl enable apache2
