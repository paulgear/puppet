# Description:	fail2ban filters to block hosts sending spam or viruses
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::filters::amavis {
	fail2ban::filter { "amavis":
		failregex	=> 'amavis.*(Blocked|Passed) (INFECTED|SPAM|SPAMMY), \[<HOST>\]',
	}
}
