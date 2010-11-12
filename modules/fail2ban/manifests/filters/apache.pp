# Description:	fail2ban filters to block hosts searching for non-existent pages
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::filters::apache {
	fail2ban::filter { "apache-notfound":
		failregex	=> '^<HOST> .*HTTP.[0-9.]+. 404',
	}
}
