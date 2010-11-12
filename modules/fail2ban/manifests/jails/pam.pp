# Description:	fail2ban jail for pam
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::jails::pam {
	fail2ban::jail { "pam-generic": }
}

