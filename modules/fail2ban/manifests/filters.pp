# Description:	puppet classes for standard fail2ban filters
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::filters::amavis {
	# block hosts sending spam or viruses
	fail2ban::filter { "amavis":
		failregex	=> 'amavis.*(Blocked|Passed) (INFECTED|SPAM|SPAMMY), \[<HOST>\]',
	}
}

class fail2ban::filters::apache {
	# block hosts searching for non-existent pages
	fail2ban::filter { "apache-notfound":
		failregex	=> '^<HOST> .*HTTP.[0-9.]+. 404',
	}
}

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

class fail2ban::filters::postfix {
	# block hosts sending excessive messages
	fail2ban::filter { "postfix-connection":
		failregex	=> 'postfix/smtpd.*: (lost connection|timeout) after (CONNECT|DATA|EHLO|MAIL) from .*\[<HOST>\]',
	}
	# block hosts greylisted by postgrey
	fail2ban::filter { "postfix-postgrey":
		failregex	=> 'reject: RCPT from (.*)\[<HOST>\]: 450 4\.7\.1',
	}
	# block hosts attempting to send to invalid users
	fail2ban::filter { "postfix-invalid-user":
		failregex	=> 'reject: RCPT from (.*)\[<HOST>\]: 550 5\.1\.1',
	}
}

