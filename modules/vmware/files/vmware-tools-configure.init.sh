#!/bin/bash
# Adapted from https://stomp.colorado.edu/blog/2010/06/10/on-vmware-tools-and-linux/

#######################
#VMWare Tools init script
#Version: 1.2
#Created: 2009-09-28
#Author:Erinn Looney-Triggs
#Revised: 2010-06-10
#Revised by: Erinn Looney-Triggs
#Revision history:
# 1.2 Add license text
# 1.1 Cleanup typos
#
#License:
#vmware-tools-install Performs automated re-installs
#of vmware-tools when the kernel is updated.
#Copyright (C) 2010  Erinn Looney-Triggs
#Changes Copyright (c) 2010  Queensland Baptist Care <http://qbc.com.au/>
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU Affero General Public License as
#published by the Free Software Foundation, either version 3 of the
#License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU Affero General Public License for more details.
#
#You should have received a copy of the GNU Affero General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
########################

#
# chkconfig: 12345 06 99
# processname: VMware
# description: VMware tools installer

#Tests for existence of LSB functions script, sources said script
#this will only work on linux, but it should work on all LSB complaint
#systems.
lsb_functions='/lib/lsb/init-functions'

if [ -f ${lsb_functions} ] ; then
	source ${lsb_functions}
else
	log_success_msg()
	{
		printf '%s\n' " Success! $@"
	}
	log_failure_msg()
	{
		printf '%s\n' " FAILED $@ ($?)"
		exit 2
	}
fi

VMWARE_TOOLS='/usr/bin/vmware-config-tools.pl'
VERSION=`uname -r`
INSTALLED_FILE="/lib/modules/$VERSION/misc/.vmware_installed"

configure()
{
	if [ ! -e ${INSTALLED_FILE} ]; then
		if ${VMWARE_TOOLS} --default > /dev/null ; then
			touch ${INSTALLED_FILE}
			/sbin/service network restart
			log_success_msg "$@"
		else
			log_failure_msg "$@"
		fi
	else
		log_success_msg "VMware tools already configured for $VERSION"
	fi
}

case "$1" in
stop)
	;;
start|restart|reload)
	configure "Configure VMware tools - $1"
	;;
*)
	printf '%s\n' "Usage: $0 {start|stop|restart|reload}"
	exit 1
	;;
esac

exit 0
