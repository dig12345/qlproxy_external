#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install required python libs
apt-get -y install python-setuptools python-ldap sudo

# install django
easy_install django==1.6.11

# install apache and mod_wsgi
apt-get -y install apache2 libapache2-mod-wsgi
