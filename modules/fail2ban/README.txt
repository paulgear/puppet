This module is designed to allow modular management of fail2ban from puppet.

NOTES
-----

- Does not provide comprehensive coverage of fail2ban features.  Patches
  gratefully accepted; feature requests cheerfully considered.  :-)
- It would be more elegant if fail2ban natively supported /etc/fail2ban/jail.d.
  Until that occurs, this module requires puppet-concat from
	http://github.com/ripienaar/puppet-concat
