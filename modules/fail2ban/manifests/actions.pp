# Description:	puppet classes for standard fail2ban actions
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::actions::restart_winbind {
	fail2ban::action { "restart-winbind":
		actionban	=> 'service winbind restart',
		actionunban	=> '',
	}
}

class fail2ban::actions::route {
	# null-route hosts (so that no traffic can be sent to them)
	fail2ban::action { "route":
		actionban	=> 'ip route add unreachable <ip>',
		actionunban	=> 'ip route del unreachable <ip>',
	}
}

class fail2ban::actions::shorewall {
	# blacklist hosts using shorewall (so that no traffic can be received from them)
	fail2ban::action { "shorewall":
		actionban	=> 'shorewall drop <ip>',
		actionunban	=> 'shorewall allow <ip>',
	}
}

