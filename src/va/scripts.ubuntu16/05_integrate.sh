#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# replace the squid config
if [ ! -f /etc/squid/squid.conf.default ]; then
    cp -f /etc/squid/squid.conf /etc/squid/squid.conf.default
fi
cp -f squid.conf /etc/squid/squid.conf

# create squid storage for mimicked ssl certificates
SSL_DB=/var/spool/squid_ssldb
if [ -d $SSL_DB ]; then
	rm -Rf $SSL_DB
fi

/usr/lib/squid/ssl_crtd -c -s $SSL_DB
if [ $? -ne 0 ]; then
    echo "Error $? while initializing SSL certificate storage, exiting..."
    exit 1
fi
chown -R proxy:proxy $SSL_DB

# reset owner of installation path
chown -R websafety:websafety /opt/websafety

# restart all daemons
systemctl restart wsmgrd
systemctl restart wsicapd
systemctl restart squid
systemctl restart gunicorn
systemctl restart nginx

# and tell it
echo "SUCCESS!"