# Description:	puppet classes for standard fail2ban jails
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

class fail2ban::jails::apache {
	fail2ban::jail { [ "apache", "apache-badbots", "apache-noscript", "apache-overflows" ]:
		action		=> '%(action_mwl)s',
		logpath		=> '/var/log/apache*/*access*',
		port		=> 'http,https',
	}
	fail2ban::jail { "apache-notfound":
		findtime	=> 300,
		logpath		=> '/var/log/apache*/*access*',
		maxretry	=> 5,
		port		=> 'http,https',
	}
}

class fail2ban::jails::hula {
	fail2ban::jail { "hulasmtp-badpass":
		logpath		=> '/var/log/auth.log',
		port		=> 'smtp',
	}
	fail2ban::jail { "hulasmtp-inputchoke":
		findtime	=> 60,
		logpath		=> '/var/log/daemon.log',
		maxretry	=> 5,
		port		=> 'smtp',
	}
	fail2ban::jail { "hulasmtp-relay":
		logpath		=> '/var/log/daemon.log',
		maxretry	=> 1,
		port		=> 'smtp',
	}
}

class fail2ban::jails::pam {
	fail2ban::jail { "pam-generic": }
}

class fail2ban::jails::postfix {
	# enable default postfix jail
	fail2ban::jail { "postfix": }

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

class fail2ban::jails::ssh {
	fail2ban::jail { "ssh": }
	fail2ban::jail { "ssh-ddos": }
}

class fail2ban::jails::winbind {
	fail2ban::jail { "winbind":
		findtime	=> 60,
		logpath		=> '/var/log/messages',
		maxretry	=> 2,
		filter		=> 'winbind-remote-error',
		action		=> 'winbind-restart',
	}
}

