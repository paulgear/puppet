# puppet class to customise syslog

class syslog {

	$logdir = "/var/log/sysmgt"
	$rotdir = "$logdir/RotatedLogs"

	$owner = "root"
	$group = "root"

	$provider = $operatingsystem ? {
		"CentOS"	=> $operatingsystemrelease ? {
			/^5/	=>	"sysklogd",
			default	=>	"rsyslog",
		},
		"Debian"	=> "rsyslog",
		"Ubuntu"	=> "rsyslog",
	}
	$notifier = $provider ? {
		rsyslog		=> "rsyslog::service",
		sysklogd	=> "sysklogd::exec",
	}
	include $provider

	# We put the configuration in /etc/rsyslog.d even if rsyslog is not
	# the provider - with sysklogd this configuration is concatenated
	# and added to the end of /etc/syslog.conf.
	$confdir = "/etc/rsyslog.d"
	file { $confdir:
		ensure		=> directory,
		require		=> Class["${provider}::package"],
	}
}

# note: $name must not contain spaces
define syslog::add_config( $content ) {
	include syslog
	file { "${syslog::confdir}/00-puppet-$name.conf":
		ensure		=> file,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> 644,
		notify		=> Class["$syslog::notifier"],
		content		=> $content,
	}
}

define syslog::dir ( $mode = 755 ) {
	include syslog
	include syslog::migrate_old_sysmgt
	file { $name:
		ensure		=> directory,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> $mode,
		require		=> Class["syslog::migrate_old_sysmgt"],
	}
}

define syslog::file ( $mode = 644 ) {
	include syslog
	file { "$syslog::logdir/$name":
		ensure		=> file,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> $mode,
		require		=> File["$syslog::logdir"],
	}
}

define syslog::files (
		$files = [
			"auth",
			"cron",
			"daemon",
			"ftp",
			"kern",
			"local0",
			"local1",
			"local2",
			"local3",
			"local4",
			"local5",
			"local6",
			"local7",
			"lpr",
			"mail",
			"news",
			"syslog",
			"user",
			"uucp",
		],
		$priv_files = [
			"all",
			"authpriv",
		]
) {
	include syslog
	include syslog::migrate_old_sysmgt
	include syslog::remove_old_puppet

	$logrotate = "/etc/logrotate.d/00-puppet-sysmgt"

	# create dirs
	syslog::dir { [ "$syslog::logdir", "$syslog::rotdir" ]: }

	# create files
	syslog::file { $files: }
	syslog::file { $priv_files: mode => 640 }

	# logrotate configuration for the local files
	file { $logrotate:
		ensure		=> file,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> 644,
		content		=> "# Managed by puppet - do not edit here
${syslog::logdir}/* {
	rotate 52
	weekly
	dateext
	compress
	delaycompress
	missingok
	notifempty
	olddir ${syslog::rotdir}/
}
",
	}

	syslog::add_config { "sysmgt":
		content		=> template("syslog/sysmgt.conf.erb"),
	}

}

define syslog::remote ( $host ) {
	syslog::add_config { "remote":
		content => "# Created by puppet on $server - do not edit here
*.info	@$host
",
	}
}

define syslog::remove_config() {
	include syslog
	file { "${syslog::confdir}/00-puppet-$name.conf":
		ensure		=> absent,
		notify		=> Class["$syslog::notifier"],
	}

	$rsyslog_logrotate = "/etc/logrotate.d/rsyslog"
	file { $rsyslog_logrotate:
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		content		=> "# Managed by puppet - do not edit here
/var/log/syslog
/var/log/mail.info
/var/log/mail.warn
/var/log/mail.err
/var/log/mail.log
/var/log/maillog
/var/log/daemon.log
/var/log/kern.log
/var/log/auth.log
/var/log/user.log
/var/log/lpr.log
/var/log/cron.log
/var/log/debug
/var/log/messages
{
        rotate 52
        weekly
	dateext
        missingok
        notifempty
        compress
        delaycompress
        sharedscripts
        postrotate
		/etc/init.d/rsyslog reload >/dev/null 2>&1 || true
		kill -HUP `cat /var/run/rsyslogd.pid`
        endscript
}

define syslog::tty ( $tty = "tty12" ) {
	syslog::add_config { "tty":
		content	=> "# Created by puppet on $server - do not edit here
*.info /dev/$tty
",
	}
}

class syslog::migrate_old_sysmgt {
	exec { "migrate old sysmgt":
		command		=> "mv -f /var/opt/sysmgt/log ${syslog::logdir}",
		logoutput	=> true,
		onlyif		=> "test -e /var/opt/sysmgt/log",
		before		=> File["${syslog::logdir}"],
	}
	file { "/etc/logrotate.d/sysmgt":
		ensure		=> absent,
	}
}

class syslog::remove_old_puppet {
	$files = [
		"/etc/rsyslog.d/00-puppet-kernel.conf",
		"/etc/rsyslog.d/00-puppet-maillog.conf",
		"/etc/rsyslog.d/00-puppet-messages.conf",
		"/etc/logrotate.d/syslog-sysmgt"
	]
	file { $files:
		ensure		=> absent,
		notify		=> Class["$syslog::notifier"],
	}
}

class syslog::local_files {
	syslog::files { $fqdn: }
}

class syslog::limited_local_files {
	syslog::files { $fqdn:
		files	=> [],
	}
}

class syslog::noremote {
	syslog::remove_config { "remote": }
}

