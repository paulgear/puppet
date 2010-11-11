#!/bin/sh

set -e
set -u

PATH=/usr/bin:/bin/:/usr/sbin:/sbin:$PATH

echo "deb http://ftp.iinet.net.au/pub/debian-backports lenny-backports main" > /etc/apt/sources.list.d/lenny-backports.list
wget -qq -O - 'http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0xEA8E8B2116BA136C' | apt-key add -
aptitude update
aptitude install -y ssh lsb-release puppet/lenny-backports
