#
# puppet client management
#

class puppet::client {
	include puppet::client::bucket_clean
	include puppet::client::report
	include puppet::client::service
	include puppet::client::weekly
}

class puppet::client::report {
	include puppet::client::service
	$cfg = "/etc/puppet/puppet.conf"
	$tag = $puppetversion ? {
		/0\.25.*/	=> "puppetd",
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

class puppet::client::weekly {
	# restart puppet daemon weekly
	cron_job { "puppet-restart":
		interval	=> "weekly",
		script		=> "#!/bin/sh
/etc/init.d/puppet restart >/dev/null 2>&1
"
	}
}

class puppet::client::bucket_clean {
	# clean out clientbucket
	cron_job { "puppet-clientbucket-clean":
		interval	=> "weekly",
		script		=> "#!/bin/sh
cd /var/lib/puppet/clientbucket
du -mxs .
df -m .
find . -type f -mtime +99 -print0 | xargs -0 rm -f
find . -type d -print0 | xargs -0 rmdir 2>/dev/null
du -mxs .
df -m .
"
	}
}

