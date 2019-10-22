#!/bin/bash
#This script will prepare a Cloud VM (Digital Ocean) into a Kali Machine.
#Assuming you are Root:
apt update
apt install dirmngr -y
clear
echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 7D8D0BF6
clear
apt update && apt dist-upgrade -y
echo "Ready To Install Kali Programs"