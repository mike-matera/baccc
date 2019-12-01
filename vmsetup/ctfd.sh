#!/bin/bash
#CTFd Install and Configuration Script
#Created by Jacobs Otto and Irvin Lemus

CTF_NAME="CTFd"

#Root Required
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

#Perform updates and upgrades (upgrade isn't that important).
apt update && apt upgrade -y

#Setup CTFd home.
mkdir /home/CTFd;
cd /home/CTFd;

#Get CTFd.
git clone https://github.com/CTFd/CTFd.git;
cd CTFd;
./prepare.sh;

#Uncomment if you want to edit the config file.
#vim CTFd/config.py;

echo "Y2QgL2hvbWUvQ1RGZC9DVEZkCnNlcnZpY2Ugbmdpbnggc3RhcnQKbm9odXAgZ3VuaWNvcm4gLWMgZ3VuaWNvcm4uY2ZnICJDVEZkOmNyZWF0ZV9hcHAoKSImCg==" | base64 -d >> /home/CTFd/CTFd/start.sh
echo "aW1wb3J0IG11bHRpcHJvY2Vzc2luZwoKYmluZCA9ICIwLjAuMC4wOjgwMDAiCndvcmtlcnMgPSBtdWx0aXByb2Nlc3NpbmcuY3B1X2NvdW50KCkgKiAyICsgMQp0aHJlYWRzID0gMgp3b3JrZXJfY2xhc3MgPSAiZ2V2ZW50Igp3b3JrZXJfY29ubmVjdGlvbnMgPSA0MDAKdGltZW91dCA9IDMwCmtlZXBhbGl2ZSA9IDIK" | base64 -d >> /home/CTFd/CTFd/gunicorn.cfg
chmod +x start.sh

#Install nginx.
apt-get -y install nginx;
ufw allow 'Nginx Full';
ufw allow 'Nginx HTTP';
ufw allow 'Nginx HTTPS';

#Install certbot.
add-apt-repository ppa:certbot/certbot -y;
apt update;
apt install certbot python-certbot-nginx -y;

#Create File to run CTFd at boot
echo "IyEvYmluL2Jhc2gKI1NldHVwIHBlcnNpc3RlbmNlIGZvciBDVEZkLgpDVEZfTkFNRT0iQ1RGZCIKY2QgL2V0Yy9jcm9uLmQvOwplY2hvIC1lICJTSEVMTD0vYmluL3NoIiA+ICRDVEZfTkFNRTsKZWNobyAtZSAiUEFUSD0vdXNyL2xvY2FsL3NiaW46L3Vzci9sb2NhbC9iaW46L3NiaW46L2JpbjovdXNyL3NiaW46L3Vzci9iaW4iID4+ICRDVEZfTkFNRTsKZWNobyAtZSAiQHJlYm9vdCAgIHJvb3QgICAgL2hvbWUvQ1RGZC9DVEZkL3N0YXJ0LnNoIiA+PiAkQ1RGX05BTUU7" | base64 -d >> /home/CTFd/CTFd/cron.sh
chmod +x cron.sh && ./cron.sh;
./start.sh;
echo "########################################################################"
echo "CTFd is ready"
echo "Please go to the IP address or Domain Name at port 8000 to continue"
echo "########################################################################"