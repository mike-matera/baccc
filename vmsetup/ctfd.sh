#!/bin/bash
#CTFd Install and Configuration Script
#Created by Jacobs Otto and Irvin Lemus

CTF_NAME="CTFd"

#Root Required
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

function setup {
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

#Adding Postgres SQL
#pw=$(head /dev/urandom | md5sum)
#dbpw=$(echo $pw | awk '{print $1}')
#su postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password '$dbpw';\""
#CREATE EXTENSION adminpack;
#echo "postgres://postgres:$dbpw@localhost/ctfd" >> config.py
#python config.py
}

function https {
#Install nginx.
apt-get -y install nginx;
ufw allow 'Nginx Full';
ufw allow 'Nginx HTTP';
ufw allow 'Nginx HTTPS';

#Nginx Configuration
rm /etc/nginx/nginx.conf
echo "dXNlciB3d3ctZGF0YTsKd29ya2VyX3Byb2Nlc3NlcyA0OwpwaWQgL3J1bi9uZ2lueC5waWQ7Cndvcmtlcl9ybGltaXRfbm9maWxlIDE1MDA7CgpldmVudHMgewogICAgCXdvcmtlcl9jb25uZWN0aW9ucyAxNTAwOwogICAgCSMgbXVsdGlfYWNjZXB0IG9uOwp9CgpodHRwIHsKCiAgICAJb3Blbl9maWxlX2NhY2hlIG1heD0xMDI0IGluYWN0aXZlPTEwczsKICAgIAlvcGVuX2ZpbGVfY2FjaGVfdmFsaWQgMTIwczsKICAgIAlvcGVuX2ZpbGVfY2FjaGVfbWluX3VzZXMgMTsKICAgIAlvcGVuX2ZpbGVfY2FjaGVfZXJyb3JzIG9uOwoKICAgIAkjIwogICAgCSMgQmFzaWMgU2V0dGluZ3MKICAgIAkjIwoKICAgIAlzZW5kZmlsZSBvbjsKICAgIAl0Y3Bfbm9wdXNoIG9uOwogICAgCXRjcF9ub2RlbGF5IG9uOwogICAgCWtlZXBhbGl2ZV90aW1lb3V0IDY1OwogICAgCXR5cGVzX2hhc2hfbWF4X3NpemUgMjA0ODsKICAgIAkjIHNlcnZlcl90b2tlbnMgb2ZmOwoKICAgIAkjIHNlcnZlcl9uYW1lc19oYXNoX2J1Y2tldF9zaXplIDY0OwogICAgCSMgc2VydmVyX25hbWVfaW5fcmVkaXJlY3Qgb2ZmOwoKICAgIAlpbmNsdWRlIC9ldGMvbmdpbngvbWltZS50eXBlczsKICAgIAlkZWZhdWx0X3R5cGUgYXBwbGljYXRpb24vb2N0ZXQtc3RyZWFtOwoKICAgIAkjIwogICAgCSMgU1NMIFNldHRpbmdzCiAgICAJIyMKCiAgICAJc3NsX3Byb3RvY29scyBUTFN2MSBUTFN2MS4xIFRMU3YxLjI7ICMgRHJvcHBpbmcgU1NMdjMsIHJlZjogUE9PRExFCiAgICAJc3NsX3ByZWZlcl9zZXJ2ZXJfY2lwaGVycyBvbjsKCiAgICAJIyMKICAgIAkjIExvZ2dpbmcgU2V0dGluZ3MKICAgIAkjIwoKICAgIAlhY2Nlc3NfbG9nIC92YXIvbG9nL25naW54L2FjY2Vzcy5sb2c7CiAgICAJZXJyb3JfbG9nIC92YXIvbG9nL25naW54L2Vycm9yLmxvZzsKCiAgICAJIyMKICAgIAkjIEd6aXAgU2V0dGluZ3MKICAgIAkjIwoKICAgIAlnemlwIG9uOwogICAgCWd6aXBfZGlzYWJsZSAibXNpZTYiOwoKICAgIAkjIGd6aXBfdmFyeSBvbjsKICAgIAkjIGd6aXBfcHJveGllZCBhbnk7CiAgICAJIyBnemlwX2NvbXBfbGV2ZWwgNjsKICAgIAkjIGd6aXBfYnVmZmVycyAxNiA4azsKICAgIAkjIGd6aXBfaHR0cF92ZXJzaW9uIDEuMTsKICAgIAkjIGd6aXBfdHlwZXMgdGV4dC9wbGFpbiB0ZXh0L2NzcyBhcHBsaWNhdGlvbi9qc29uIGFwcGxpY2F0aW9uL2phdmFzY3JpcHQgdGV4dC94bWwgYXBwbGljYXRpb24veG1sIGFwcGxpY2F0aW9uL3htbCtyc3MgdGV4dC9qYXZhc2NyaXB0OwoKICAgIAkjIwogICAgCSMgVmlydHVhbCBIb3N0IENvbmZpZ3MKICAgIAkjIwoKICAgIAlpbmNsdWRlIC9ldGMvbmdpbngvY29uZi5kLyouY29uZjsKICAgIAlpbmNsdWRlIC9ldGMvbmdpbngvc2l0ZXMtZW5hYmxlZC8qOwp9CgoKI21haWwgewojICAgCSMgU2VlIHNhbXBsZSBhdXRoZW50aWNhdGlvbiBzY3JpcHQgYXQ6CiMgICAJIyBodHRwOi8vd2lraS5uZ2lueC5vcmcvSW1hcEF1dGhlbnRpY2F0ZVdpdGhBcGFjaGVQaHBTY3JpcHQKIwojICAgCSMgYXV0aF9odHRwIGxvY2FsaG9zdC9hdXRoLnBocDsKIyAgIAkjIHBvcDNfY2FwYWJpbGl0aWVzICJUT1AiICJVU0VSIjsKIyAgIAkjIGltYXBfY2FwYWJpbGl0aWVzICJJTUFQNHJldjEiICJVSURQTFVTIjsKIwojICAgCXNlcnZlciB7CiMgICAgICAgICAgIAlsaXN0ZW4gCWxvY2FsaG9zdDoxMTA7CiMgICAgICAgICAgIAlwcm90b2NvbCAgIHBvcDM7CiMgICAgICAgICAgIAlwcm94eSAgCW9uOwojICAgCX0KIwojICAgCXNlcnZlciB7CiMgICAgICAgICAgIAlsaXN0ZW4gCWxvY2FsaG9zdDoxNDM7CiMgICAgICAgICAgIAlwcm90b2NvbCAgIGltYXA7CiMgICAgICAgICAgIAlwcm94eSAgCW9uOwojICAgCX0KI30KCg==" | base64 -d >> /etc/nginx/nginx.conf
echo "cHJveHlfY2FjaGVfcGF0aCAvaG9tZS9DVEZkL25naW54Q2FjaGUgbGV2ZWxzPTE6MiBrZXlzX3pvbmU9bXlfY2FjaGU6MTBtIG1heF9zaXplPThnCiAgICAgICAgICAgICAJaW5hY3RpdmU9MTBtIHVzZV90ZW1wX3BhdGg9b2ZmOwpzZXJ2ZXIgewogICAgCWxpc3RlbiA4MCBkZWZhdWx0X3NlcnZlcjsKICAgIAlzZXJ2ZXJfbmFtZSBfOwogICAgCXJldHVybiAzMDEgaHR0cHM6Ly8kaG9zdCRyZXF1ZXN0X3VyaTsKfQoKc2VydmVyIHsKICAgIAlsaXN0ZW4gNDQzIHNzbDsKICAgIAkjc3NsX2NlcnRpZmljYXRlIC9ldGMvbGV0c2VuY3J5cHQvbGl2ZS9ZT1VSQ1RGRE9NQUlOLkRPTUFJTi9mdWxsY2hhaW4ucGVtOwogICAgCSNzc2xfY2VydGlmaWNhdGVfa2V5IC9ldGMvbGV0c2VuY3J5cHQvbGl2ZS9ZT1VSQ1RGRE9NQUlOLkRPTUFJTi9wcml2a2V5LnBlbTsKICAgIAkjaW5jbHVkZSAvZXRjL2xldHNlbmNyeXB0L29wdGlvbnMtc3NsLW5naW54LmNvbmY7CiAgICAJc2VydmVyX25hbWUgQ1RGZDsKICAgIAlsb2NhdGlvbiA9IC9mYXZpY29uLmljbyB7IGFjY2Vzc19sb2cgb2ZmOyBsb2dfbm90X2ZvdW5kIG9mZjsgfQogbG9jYXRpb24gL3N0YXRpYy8gewogICAgCXJvb3QgL2hvbWUvQ1RGZC9DVEZkL0NURmQ7CiB9CiAgICAJbG9jYXRpb24gLyB7CiAgICAJaW5jbHVkZSBwcm94eV9wYXJhbXM7CiAgICAJcHJveHlfY2FjaGUgbXlfY2FjaGU7CiAgICAJcHJveHlfcGFzcyBodHRwOi8vbG9jYWxob3N0OjgwMDA7CiAgICAJfQogfQoK" | base64 -d >> /etc/nginx/sites-available/CTFd
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/CTFd /etc/nginx/sites-enabled/default

#Install certbot.
nohup /home/CTFd/CTFd/start.sh
sleep 10
nohup /home/CTFd/CTFd/start.sh &
add-apt-repository ppa:certbot/certbot -y;
apt update;
apt install certbot python-certbot-nginx -y;
certbot --nginx certonly
sed -i '11i\         ssl_certificate /etc/letsencrypt/live/'$dns'/fullchain.pem;\' /etc/nginx/sites-available/CTFd
sed -i '12i\         ssl_certificate_key /etc/letsencrypt/live/'$dns'/privkey.pem;\' /etc/nginx/sites-available/CTFd
sed -i '13i\         include /etc/letsencrypt/options-ssl-nginx.conf;\' /etc/nginx/sites-available/CTFd
/etc/init.d/nginx restart

#Create File to run CTFd at boot
echo "IyEvYmluL2Jhc2gKI1NldHVwIHBlcnNpc3RlbmNlIGZvciBDVEZkLgpDVEZfTkFNRT0iQ1RGZCIKY2QgL2V0Yy9jcm9uLmQvOwplY2hvIC1lICJTSEVMTD0vYmluL3NoIiA+ICRDVEZfTkFNRTsKZWNobyAtZSAiUEFUSD0vdXNyL2xvY2FsL3NiaW46L3Vzci9sb2NhbC9iaW46L3NiaW46L2JpbjovdXNyL3NiaW46L3Vzci9iaW4iID4+ICRDVEZfTkFNRTsKZWNobyAtZSAiQHJlYm9vdCAgIHJvb3QgICAgL2hvbWUvQ1RGZC9DVEZkL3N0YXJ0LnNoIiA+PiAkQ1RGX05BTUU7" | base64 -d >> /home/CTFd/CTFd/cron.sh
chmod +x cron.sh && ./cron.sh;
echo "########################################################################"
echo "CTFd is ready"
echo "Please go to the https://"$dns" to continue."
echo "########################################################################"
}

function http {
#Create File to run CTFd at boot
echo "aW1wb3J0IG11bHRpcHJvY2Vzc2luZwoKYmluZCA9ICIwLjAuMC4wOjgwIgp3b3JrZXJzID0gbXVsdGlwcm9jZXNzaW5nLmNwdV9jb3VudCgpICogMiArIDEKdGhyZWFkcyA9IDIKd29ya2VyX2NsYXNzID0gImdldmVudCIKd29ya2VyX2Nvbm5lY3Rpb25zID0gNDAwCnRpbWVvdXQgPSAzMAprZWVwYWxpdmUgPSAyCgo=" | base64 -d >> /home/CTFd/CTFd/gunicorn.cfg
echo "IyEvYmluL2Jhc2gKI1NldHVwIHBlcnNpc3RlbmNlIGZvciBDVEZkLgpDVEZfTkFNRT0iQ1RGZCIKY2QgL2V0Yy9jcm9uLmQvOwplY2hvIC1lICJTSEVMTD0vYmluL3NoIiA+ICRDVEZfTkFNRTsKZWNobyAtZSAiUEFUSD0vdXNyL2xvY2FsL3NiaW46L3Vzci9sb2NhbC9iaW46L3NiaW46L2JpbjovdXNyL3NiaW46L3Vzci9iaW4iID4+ICRDVEZfTkFNRTsKZWNobyAtZSAiQHJlYm9vdCAgIHJvb3QgICAgL2hvbWUvQ1RGZC9DVEZkL3N0YXJ0LnNoIiA+PiAkQ1RGX05BTUU7" | base64 -d >> /home/CTFd/CTFd/cron.sh
chmod +x cron.sh && ./cron.sh;
nohup /home/CTFd/CTFd/start.sh
sleep 10
nohup /home/CTFd/CTFd/start.sh &
echo "########################################################################"
echo "CTFd is ready without a Domain"
echo "Please go to the IP address in a browser continue."
echo "########################################################################"
}

echo "########################################################################"
echo "This script will install and do the intial configuration for CTFd."
echo "Do you have an FQDN for this server (y/n)"
echo "#######################################################################"
read answer
if [[ $answer == y ]]; then
	echo "What is the FQDN?"
	read dns
	setup
	https
else
	setup
	http
fi