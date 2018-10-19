#!/bin/bash
if [ $# > 1 ]
then
	if [[ "$1" == "--site" ]]
	then
		rm -rf /var/www/fake/epitech/*
		mkdir /var/www/fake/epitech/portal/
		mkdir /var/www/fake/epitech/perso/
		mkdir /var/www/fake/epitech/admin/
		for line in $(curl https://raw.githubusercontent.com/SwSl/Q2hlcm9rZWU/master/map);
		do
			curl https://raw.githubusercontent.com/SwSl/Q2hlcm9rZWU/master$line > /var/www/fake/epitech$line
		done
		exit
	fi
fi
yum install httpd mod_ssl openssl mod_php php-pdo php-mysqli -y
systemctl enable httpd.service
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
cat << EOF > /etc/httpd/conf.d/vhosts.conf
ServerName epitech.fake

<VirtualHost portal.epitech.fake:80>
	ServerAdmin admin@epitech.fake
	DocumentRoot /var/www/fake/epitech/portal
	ServerName portal.epitech.fake
	ErrorLog "logs/fake.epitech.portal-error.log"
	CustomLog "logs/fake.epitech.portal-access.log" common
</VirtualHost>

<VirtualHost portal.epitech.fake:443>
	ServerAdmin admin@epitech.fake
	DocumentRoot /var/www/fake/epitech/portal
	ServerName portal.epitech.fake
	SSLEngine On
	SSLCertificateFile "/etc/pki/tls/certs/server.crt"
	SSLCertificateKeyFile "/etc/pki/tls/private/server.key"
	ErrorLog "logs/fake.epitech.portal-error.log"
	CustomLog "logs/fake.epitech.portal-access.log" common
</VirtualHost>

<VirtualHost admin.epitech.fake:80>
	ServerAdmin admin@epitech.fake
	DocumentRoot /var/www/fake/epitech/admin
	ServerName admin.epitech.fake
	ErrorLog "logs/fake.epitech.admin-error.log"
	CustomLog "logs/fake.epitech.admin-access.log" common
	<Directory />
		AuthType Basic
		AuthName "Please Log In"
		AuthUserFile /var/www/fake/epitech/admin/.htpasswd
		Require valid-user
	</Directory>
</VirtualHost>

<VirtualHost admin.epitech.fake:443>
	ServerAdmin admin@epitech.fake
	DocumentRoot /var/www/fake/epitech/admin
	ServerName admin.epitech.fake
	SSLEngine On
	SSLCertificateFile "/etc/pki/tls/certs/server.crt"
	SSLCertificateKeyFile "/etc/pki/tls/private/server.key"
	ErrorLog "logs/fake.epitech.admin-error.log"
	CustomLog "logs/fake.epitech.admin-access.log" common
	<Directory />
		AuthType Basic
		AuthName "Please Log In"
		AuthUserFile /var/www/fake/epitech/admin/.htpasswd
		Require valid-user
	</Directory>
</VirtualHost>

<VirtualHost perso.epitech.fake:443>
	ServerAdmin admin@epitech.fake
	DocumentRoot /var/www/fake/epitech/perso
	ServerName perso.epitech.fake
	SSLEngine On
	SSLCertificateFile "/etc/pki/tls/certs/server.crt"
	SSLCertificateKeyFile "/etc/pki/tls/private/server.key"
	ErrorLog "logs/fake.epitech.perso-error.log"
	CustomLog "logs/fake.epitech.perso-access.log" common
</VirtualHost>
EOF
cat << EOF > /etc/httpd/conf.d/openssl.cnf
[req]
default_bits=2048
prompt=no
default_md=sha256
x509_extensions=v3_req
distinguished_name=dn

[dn]
C=FR
ST=France
L=Montpellier
O=GirardinCreations
emailAddress=admin@epitech.fake
CN=*.epitech.fake

[v3_req]
subjectAltName=@alt_names

[alt_names]
DNS.1=epitech.fake
DNS.2=portal.epitech.fake
DNS.3=admin.epitech.fake
DNS.4=perso.epitech.fake
EOF
openssl genrsa -out /etc/httpd/conf.d/server.key 2048
openssl req -new -x509 -config /etc/httpd/conf.d/openssl.cnf -key /etc/httpd/conf.d/server.key -days 365 -out /etc/httpd/conf.d/server.crt -nodes
cp /etc/httpd/conf.d/server.crt /etc/pki/tls/certs
cp /etc/httpd/conf.d/server.key /etc/pki/tls/private
chmod go-r /etc/pki/tls/private/server.key
chmod go-r /etc/pki/tls/certs/server.crt
mkdir /var/www/fake/
mkdir /var/www/fake/epitech/
mkdir /var/www/fake/epitech/portal/
mkdir /var/www/fake/epitech/perso/
mkdir /var/www/fake/epitech/admin/
echo $(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/') epitech.fake portal.epitech.fake admin.epitech.fake perso.epitech.fake >> /etc/hosts
echo > /etc/httpd/conf.d/welcome.conf
for line in $(curl https://raw.githubusercontent.com/SwSl/Q2hlcm9rZWU/master/map);
do
	curl https://raw.githubusercontent.com/SwSl/Q2hlcm9rZWU/master$line > /var/www/fake/epitech$line
done
reboot
