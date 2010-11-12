# Description:	fail2ban action to null-route hosts (so that no traffic can be sent to them)
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::actions::route {
	fail2ban::action { "route":
		actionban	=> 'ip route add unreachable <ip>',
		actionunban	=> 'ip route del unreachable <ip>',
	}
}

