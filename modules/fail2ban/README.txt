This is a module designed to allow modular management of fail2ban from puppet.

Author:		Paul Gear <puppet@libertysys.com.au>
License:	GPLv3
Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

NOTE: The kind support and encouragement of Queensland Baptist Care
<http://www.qbc.com.au/> in the development of this module is gratefully
acknowledged.

See http://www.gnu.org/licenses/gpl.html or COPYING.txt at the top of this
repository for full license details.

Notes:
- Provides far from comprehensive coverage of fail2ban features.
- It would be more elegant if fail2ban natively supported /etc/fail2ban/jail.d.
  Until that occurs, this module requires puppet-concat from
	http://github.com/ripienaar/puppet-concat
