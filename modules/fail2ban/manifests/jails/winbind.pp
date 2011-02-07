# Description:	fail2ban jail for winbind
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::jails::winbind {
	fail2ban::jail { "winbind":
		findtime	=> 60,
		logpath		=> '/var/log/sysmgt/all',
		maxretry	=> 2,
		filtername	=> 'winbind-remote-error',
		action		=> 'winbind-restart',
	}
}

