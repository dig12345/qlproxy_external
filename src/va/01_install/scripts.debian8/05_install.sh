#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install some more required packages
# apt-get -y install ssl-cert
apt-get -y install squid-langpack

# get arch
ARCH="amd64"
cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
if [ $? -eq 0 ]; then
	ARCH="armhf"
fi

# decend into working directory
pushd build/squid3

# install ecap packages
dpkg --install squid-common_3.5.22-1_all.deb
dpkg --install squid_3.5.22-1_${ARCH}.deb
dpkg --install squidclient_3.5.22-1_${ARCH}.deb

# and revert
popd

# put the squid on hold to prevent updating
apt-mark hold squid squid-common
