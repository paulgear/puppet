# Description:	fail2ban action to blacklist hosts using shorewall (so that no traffic can be
#		received from them)
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::actions::shorewall {
	fail2ban::action { "shorewall":
		actionban	=> 'shorewall drop <ip>',
		actionunban	=> 'shorewall allow <ip>',
	}
}

