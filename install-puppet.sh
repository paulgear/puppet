#!/bin/sh

set -e
set -u

PATH=/usr/bin:/bin/:/usr/sbin:/sbin:$PATH

BASE_PKGS="ssh lsb-release puppet"

case `awk '{print $1}' /etc/debian_version 2>/dev/null` in
	6.0)
		apt-get install -y $BASE_PKGS
		;;
	5.0)
		echo "deb http://ftp.iinet.net.au/pub/debian-backports lenny-backports main" > /etc/apt/sources.list.d/lenny-backports.list
		wget -qq -O - 'http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0xEA8E8B2116BA136C' | apt-key add -
		apt-get update update
		apt-get install -y $BASE_PKGS/lenny-backports
		;;
	*)
		echo "Unknown operating system - doing nothing"
		;;
esac
