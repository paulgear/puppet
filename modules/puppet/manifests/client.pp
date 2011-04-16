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

	include puppet::client::report

}

class puppet::client::report {
	include puppet::client::service
	$cfg = "/etc/puppet/puppet.conf"
	$tag = $puppetversion ? {
		0.25.1		=> "puppetd",
		default		=> "agent",
	}
	exec { "append agent section":
		command		=> "echo '[$tag]\nreport = true\n' >> $cfg",
		unless		=> "grep -q '^\\[$tag\\]' $cfg",
		notify		=> Class["puppet::client::service"],
		logoutput	=> true,
	}
}

class puppet::client::service {
	$svc = "puppet"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
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

