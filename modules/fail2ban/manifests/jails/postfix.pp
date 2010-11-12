# Description:	fail2ban jail for postfix
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::jails::postfix {
	fail2ban::jail { "postfix":
	}
	fail2ban::jail { "postfix-connection":
		findtime	=> 3600,
		logpath		=> '/var/log/mail.log',
		maxretry	=> 5,
		port		=> 'smtp',
	}
	fail2ban::jail { "postfix-invalid-user":
		bantime		=> 43200,	# 12 hours
		findtime	=> 3600,
		logpath		=> '/var/log/mail.log',
		maxretry	=> 2,
		port		=> 'smtp',
	}
	fail2ban::jail { "postgrey":
		findtime	=> 3600,
		logpath		=> '/var/log/mail.log',
		maxretry	=> 5,
		port		=> 'smtp',
	}
}

