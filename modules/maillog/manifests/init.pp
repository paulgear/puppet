#
# puppet class to push out mail scripts
#
# FIXME - Ubuntu: ensure script compatibility with new dovecot version's logging format; obsolete?
#

class maillog {

	# delete old script
	file { "/usr/local/bin/check-pop-users":
		ensure	=> absent,
	}

	file { "/usr/local/bin/check-mail-users":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/maillog/check-mail-users";
	}

	$mailto = "root@localhost"

	# delete old cron job
	cron_job { "000-check-pop-users":
		enable		=> "false",
	}

	cron_job { "000-check-mail-users":
		interval	=> "daily",
		script		=> "#!/bin/sh
# This script is managed by puppet - do not edit here!
if [ `date +%w` = 0 ]; then
	/usr/local/bin/check-mail-users | mail -s 'Weekly mail users report' $mailto
fi
",
	}

}

