# Description:	fail2ban jail for amavis
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::jails::amavis {
	fail2ban::jail { "amavis":
		port		=> "smtp",
		bantime		=> "86400",
		findtime	=> "3600",
		logpath		=> "/var/log/mail.log",
		maxretry	=> "2",
	}
}

