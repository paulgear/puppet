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
#vmware-server-configure Performs automated re-configuration
#of vmware-server when the kernel is updated.
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
# processname: VMware-server
# description: VMware server configuration

VMWARE_CONFIG='/usr/bin/vmware-config.pl -d EULA_AGREED=yes'
PROG=vmware-server-config
LOG=/var/log/$PROG
VERSION=`uname -r`
INSTALLED_FILE="/lib/modules/$VERSION/misc/.vmware_installed"

#Tests for existence of LSB functions script, sources said script
#this will only work on linux, but it should work on all LSB complaint
#systems.
lsb_functions='/lib/lsb/init-functions'

if [ -f ${lsb_functions} ] ; then
	source ${lsb_functions}
else
	log_success_msg()
	{
		printf '%s\n' "Success: $@"
		logger -t $PROG -i -p local3.info "Success: $@"
	}
	log_failure_msg()
	{
		ERR=$?
		printf '%s\n' " FAILED $@ ($ERR)"
		logger -t $PROG -i -p local3.err "FAILED $@ ($ERR)"
		exit 2
	}
fi

configure()
{
	if [ ! -e ${INSTALLED_FILE} ]; then
		if ${VMWARE_CONFIG} >${LOG} 2>&1; then
			touch ${INSTALLED_FILE}
			log_success_msg "$@"
		else
			log_failure_msg "$@ - error output in ${LOG}"
		fi
	else
		log_success_msg "VMware server already configured for $VERSION"
	fi
}

case "$1" in
stop)
	;;
start|restart|reload)
	configure "Configure VMware server - $1"
	;;
*)
	printf '%s\n' "Usage: $0 {start|stop|restart|reload}"
	exit 1
	;;
esac

exit 0
