#!/bin/bash
#This script will prepare a Cloud VM (Digital Ocean / Google Cloud) for use with 100 users via RDP with Brave, and OpenVPN installed. 
#Assuming you are Root:
apt update && apt dist-upgrade -y
apt install apt-transport-https curl xfce4 xrdp -y
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
source /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
apt update && apt install openvpn firefox gcc gdb docker.io brave-browser zip unzip openjdk-11-jre icoutils wireshark -y

#User Creation; comment the while look if you are deploying this locally
clear
echo "Creating Users"
counter=1
while  [ $counter -le 100 ]
do
        useradd -s /bin/bash -m baccc$counter
        usermod -aG sudo baccc$counter
        usermod -aG admin baccc$counter #comment this line if running on docker
        echo baccc$counter:baccc123 | chpasswd
        ((counter++))
done

#enable RDP to the VM
sed -i '7i\echo xfce4-session >~/.xsession\' /etc/xrdp/startwm.sh
service xrdp restart
echo "Ready for Work"