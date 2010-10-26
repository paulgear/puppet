This module is designed to allow modular management of fail2ban from puppet.

Author:		Paul Gear <puppet@libertysys.com.au>
License:	GPLv3
Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

See http://www.gnu.org/licenses/gpl.html or COPYING.txt in this repository for
full license details.

NOTE: The kind support and encouragement of Queensland Baptist Care
<http://www.qbc.com.au/> ICT Services in the development of this module is
gratefully acknowledged.

NOTES
-----

- Provides far from comprehensive coverage of fail2ban features.
- It would be more elegant if fail2ban natively supported /etc/fail2ban/jail.d.
  Until that occurs, this module requires puppet-concat from
	http://github.com/ripienaar/puppet-concat
