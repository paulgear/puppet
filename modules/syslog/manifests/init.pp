# puppet class to customise syslog

class syslog {

	$logdir = "/var/log/sysmgt"
	$rotdir = "$logdir/RotatedLogs"

	$owner = "root"
	$group = "root"

	$provider = $operatingsystem ? {
		"CentOS"	=> "sysklogd",
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

class syslog::migrate_old_sysmgt {
	exec { "migrate old sysmgt":
		command		=> "mv -f /var/opt/sysmgt/log ${syslog::logdir}",
		logoutput	=> true,
		onlyif		=> "test -e /var/opt/sysmgt/log",
		before		=> File["${syslog::logdir}"],
	}
}

class syslog::remove_old_puppet {
	$files = [
		"/etc/rsyslog.d/00-puppet-kernel.conf",
		"/etc/rsyslog.d/00-puppet-maillog.conf",
		"/etc/rsyslog.d/00-puppet-messages.conf",
	]
	file { $files:
		ensure		=> absent,
		notify		=> Class["$syslog::notifier"],
	}
}

class syslog::local_files {
	include syslog
	include syslog::migrate_old_sysmgt
	include syslog::remove_old_puppet

	$logrotate = "/etc/logrotate.d/syslog-sysmgt"

	$priv_files = [
		"all",
		"authpriv",
	]

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
	]

	# create dirs
	define syslog_dir ( $mode = 755 ) {
		file { $name:
			ensure		=> directory,
			owner		=> "$syslog::owner",
			group		=> "$syslog::group",
			mode		=> $mode,
			require		=> Class["syslog::migrate_old_sysmgt"],
		}
	}
	syslog_dir { [ "$syslog::logdir", "$syslog::rotdir" ]: }

	# create files
	define syslog_file ( $mode = 644 ) {
		file { "$syslog::logdir/$name":
			ensure		=> file,
			owner		=> "$syslog::owner",
			group		=> "$syslog::group",
			mode		=> $mode,
			require		=> File["$syslog::logdir"],
		}
	}
	syslog_file { $files: }
	syslog_file { $priv_files: mode => 640 }

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

define syslog::tty ( $tty = "tty12" ) {
	include syslog
	syslog::add_config { "tty":
		content	=> "# Created by puppet on $server - do not edit here
*.info /dev/$tty
",
	}
}

define syslog::remote ( $host ) {
	include syslog
	syslog::add_config { "remote":
		content => "# Created by puppet on $server - do not edit here
*.info	@$host
",
	}
}

