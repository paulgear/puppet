# Description:	fail2ban filters to block hosts abusing postfix
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::filters::postfix {
	# block hosts sending excessive messages
	fail2ban::filter { "postfix-connection":
		failregex	=> 'postfix/smtpd.*: (lost connection|timeout) after (AUTH|CONNECT|DATA|EHLO|MAIL) from .*\[<HOST>\]',
	}
	# block hosts greylisted by postgrey
	fail2ban::filter { "postfix-postgrey":
		failregex	=> 'reject: RCPT from (.*)\[<HOST>\]: 450 4\.(7\.1|2\.0)',
	}
	# block hosts attempting to send to invalid users
	fail2ban::filter { "postfix-invalid-user":
		failregex	=> 'reject: RCPT from (.*)\[<HOST>\]: 550 5\.1\.1',
	}
	# block hosts attempting to brute-force saslauthd
	fail2ban::filter { "postfix-sasl":
		failregex	=> 'postfix/smtpd.*: warning: .*\[<HOST>\]: SASL LOGIN authentication failed: authentication failure',
	}
	# block hosts attempting to send to unverified addresses
	fail2ban::filter { "postfix-unverified":
		failregex	=> 'reject: RCPT from (.*)\[<HOST>\]: 450 4\.1\.1 .*: Recipient address rejected: unverified address: host .* said: 550 5\.1\.1 ',
	}
	# remove old filters
	fail2ban::filter { [ "postfix-sasl-auth-failure", "postfix-unverified-address" ]:
		ensure		=> absent,
		failregex	=> "",
	}
}

