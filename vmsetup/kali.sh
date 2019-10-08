#!/bin/bash
#This script will prepare a Cloud VM (Digital Ocean) into a Kali Machine accessible via RDP.
#Assuming you are Root:

apt update
apt install dirmngr -y
echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 7D8D0BF6
apt update && apt dist-upgrade -y
apt install xrdp -y
apt install kali-desktop-xfce -y
apt install kali-linux-default

#User Creation; comment the while look if you are deploying this locally
clear
echo "Creating Users"
counter=1
while  [ $counter -le 2 ]
do
        usermod -aG sudo kali$counter
        echo kali$counter:password123 | chpasswd
        ((counter++))
done

#enable RDP to the VM
sed -i '7i\echo xfce4-session >~/.xsession\' /etc/xrdp/startwm.sh
service xrdp restart
echo "Ready for Work"
