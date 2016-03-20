#!/bin/bash

# integration should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# adjust the squid.conf
if [ ! -f /etc/squid/squid.conf.original ]; then
    mv /etc/squid/squid.conf /etc/squid/squid.conf.original
fi

# copy new config
cp squid.conf /etc/squid/squid.conf

# allow web ui read-only access to squid configuration file
chmod o+r /etc/squid/squid.conf

# create storage for generated ssl certificates
SSL_DB=/var/cache/squid_ssldb
if [ -d $SSL_DB ]; then
	rm -Rf $SSL_DB
fi

/usr/sbin/ssl_crtd -c -s $SSL_DB

# and change its ownership
chown -R squid $SSL_DB

# parse the resulting config just to be sure
/usr/sbin/squid -k parse

# restart squid to load all config
systemctl restart squid.service
