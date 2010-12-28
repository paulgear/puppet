# Description:	fail2ban jail for hula
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::jails::hula {
	fail2ban::jail { "hulasmtp-badpass":
		logpath		=> '/var/log/auth.log',
		port		=> 'smtp,ssmtp',
	}
	fail2ban::jail { "hulasmtp-inputchoke":
		findtime	=> 60,
		logpath		=> '/var/log/daemon.log',
		maxretry	=> 5,
		port		=> 'smtp,ssmtp',
	}
	fail2ban::jail { "hulasmtp-relay":
		logpath		=> '/var/log/daemon.log',
		maxretry	=> 1,
		port		=> 'smtp,ssmtp',
	}
}

