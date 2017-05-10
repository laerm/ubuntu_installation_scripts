echo "#######################################"
echo "UBUNTU 16.04 INSTALLER"
echo "#######################################"


sudo apt-get update
sudo apt-get upgrade


echo "#######################################"
echo "INSTALL APACHE 2"
echo "#######################################"

sudo apt-get -y install apache2
sudo a2enmod rewrite
sudo a2enmod actions


echo "#######################################"
echo "INSTALL PHP 7 FPM"
echo "#######################################"

sudo apt-get -y install libapache2-mod-fastcgi php7.0 php7.0-fpm
sudo apt-get install php7.0-cli
apt-get -y install php7.0-mysql php7.0-curl php7.0-gd php7.0-mbstring php7.0-mcrypt

echo "#######################################"
echo "INSTALL MARIA DB"
echo "#######################################"

apt-get -y install mariadb-server mariadb-client



echo "###############################################"
echo "#INSTALL WEBMIN"
echo "###############################################"

cd /root
sudo wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y install webmin
apt-get -y install apache2-suexec-custom


echo "###############################################"
echo "#INSTALL Postifix"
echo "###############################################"

sudo apt-get install postfix sasl2-bin

echo "#\n\nConfiguring postfix\n\n"

sudo adduser postfix sasl
sudo dpkg-reconfigure postfix
postconf -e 'smtpd_sasl_local_domain ='
postconf -e 'smtpd_sasl_auth_enable = yes'
postconf -e 'smtpd_sasl_security_options = noanonymous'
postconf -e 'broken_sasl_auth_clients = yes'
postconf -e 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination'
postconf -e 'inet_interfaces = all'


echo 'pwcheck_method: saslauthd' >> /etc/postfix/sasl/smtpd.conf
echo 'mech_list: plain login' >> /etc/postfix/sasl/smtpd.conf 

mkdir /etc/postfix/ssl
cd /etc/postfix/ssl/
openssl genrsa -des3 -rand /etc/hosts -out smtpd.key 1024
chmod 600 smtpd.key
openssl req -new -key smtpd.key -out smtpd.csr
openssl x509 -req -days 3650 -in smtpd.csr -signkey smtpd.key -out smtpd.crt
openssl rsa -in smtpd.key -out smtpd.key.unencrypted
mv -f smtpd.key.unencrypted smtpd.key
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650 


