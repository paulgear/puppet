#
# puppet client management
#
# FIXME: This may not be needed any more.
#
# DONE: No changes required for Ubuntu compatibility
#

class puppet::client {

	# restart puppet daemon weekly
	cron_job { "puppet-restart":
		interval	=> "weekly",
		script		=> "#!/bin/sh
/etc/init.d/puppet restart >/dev/null 2>&1
"
	}

}

class puppet::client::daily {

	# restart puppet daemon daily
	cron_job { "puppet-restart-daily":
		interval	=> "daily",
		script		=> "#!/bin/sh
/etc/init.d/puppet restart >/dev/null 2>&1
"
	}

}

