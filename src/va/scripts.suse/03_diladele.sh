#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# get qlproxy
wget http://packages.diladele.com/qlproxy/4.8.0.0EED/amd64/release/suse13/qlproxy-4.8.0-0EED.x86_64.rpm

# install it
rpm -i qlproxy-4.8.0-0EED.x86_64.rpm

# restart apache
systemctl restart apache2
