# Description:	fail2ban jail for ssh
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::jails::ssh {
	fail2ban::jail { "ssh":
		filtername	=> 'sshd',
		port		=> 'ssh',
	}
	fail2ban::jail { "ssh-ddos":
		filtername	=> 'sshd-ddos',
		port		=> 'ssh',
	}
}

