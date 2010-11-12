# Description:	fail2ban action to restart winbind
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::actions::winbind_restart {
	fail2ban::action { "winbind-restart":
		actionban	=> 'service winbind restart',
		actionunban	=> '',
	}
}
