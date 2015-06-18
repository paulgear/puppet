# Description:	fail2ban jail for apache
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::jails::apache {
	fail2ban::jail { [ "apache-auth", "apache-badbots", "apache-nohome", "apache-noscript", "apache-overflows" ]:
		action		=> '%(action_mwl)s',
		logpath		=> '/var/log/apache*/*error*',
		port		=> 'http,https',
	}
	fail2ban::jail { "apache-notfound":
		findtime	=> 300,
		logpath		=> '/var/log/apache*/*access*',
		maxretry	=> 5,
		port		=> 'http,https',
	}
	fail2ban::jail { "apache-denied":
		findtime	=> 120,
		logpath		=> '/var/log/apache*/*error*',
		maxretry	=> 3,
		port		=> 'http,https',
	}
	fail2ban::jail { "apache-generic-user":
		findtime	=> 60,
		logpath		=> '/var/log/apache*/*access*',
		maxretry	=> 5,
		port		=> 'http,https',
	}
}
