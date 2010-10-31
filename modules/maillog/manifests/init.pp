#
# puppet class to push out mail scripts
#
# FIXME - Ubuntu: ensure script compatibility with new dovecot version's logging format; obsolete?
#

class maillog {

	file { "/usr/local/bin/check-pop-users":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/maillog/check-pop-users";
	}

	$mailto = "root@localhost"

	cron_job { "000-check-pop-users":
		interval	=> "daily",
		script		=> "#!/bin/sh
# This script is managed by puppet - do not edit here!
if [ `date +%w` = 0 ]; then
	/usr/local/bin/check-pop-users | mail -s 'Weekly pop users report' $mailto
fi
",
	}

}

