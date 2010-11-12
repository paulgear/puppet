# Description:	fail2ban filters to block hosts from abusing hula
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::filters::hula {
	# block hosts guessing passwords via SMTP authentication
	fail2ban::filter { "hulasmtp-badpass":
		failregex	=> '0020001: Bad password "REMOVED" for account ".*" from <HOST>',
	}
	# block hosts sending excessive messages via SMTP
	fail2ban::filter { "hulasmtp-inputchoke":
		failregex	=> '00020015: Received message from ".*", size \d+ \(IP:<HOST>\)$',
	}
	# block hosts attempting to relay via SMTP
	fail2ban::filter { "hulasmtp-relay":
		failregex	=> '00020019: Relayed message for "Spam" to recipient ".*" from address <HOST>
		00020018: Blocked relay for recipient ".*" from address <HOST>',
	}
}

