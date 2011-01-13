# puppet class to customise syslog

class syslog {

	$dir = "/var/log/sysmgt"
	$rot = "$dir/RotatedLogs"

	$magic = "### puppet syslog configuration ###"

	$owner = "root"
	$group = "root"

	$class = $operatingsystem ? {
		centos		=> "sysklogd",
		ubuntu		=> "rsyslog",
		debian		=> "rsyslog",
	}
	include $class

	include syslog::files
	include syslog::logrotate

}

class syslog::files {
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

	define syslog_dir ( $mode = 755 ) {
		file { $name:
			ensure		=> file,
			owner		=> "$syslog::owner",
			group		=> "$syslog::group",
			mode		=> $mode,
		}
	}

	define syslog_file ( $mode = 644 ) {
		file { "$syslog::dir/$name":
			ensure		=> file,
			owner		=> "$syslog::owner",
			group		=> "$syslog::group",
			mode		=> $mode,
			require		=> File["$syslog::dir"],
		}
	}

	# create base dir for all logs
	syslog_dir { [ "$syslog::dir", "$syslog::rot" ]: }

	# create files
	syslog_file { $files: }
	syslog_file { $priv_files: mode => 640 }
}

class syslog::logrotate {
	$logrotate = "/etc/logrotate.d/syslog-sysmgt"
	file { $logrotate:
		ensure		=> file,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> 644,
		require		=> Class["syslog::files"],
		content		=> "# Managed by puppet - do not edit here
${syslog::dir}/* {
	rotate 52
	weekly
	dateext
	compress
	delaycompress
	missingok
	notifempty
	olddir ${syslog::rot}/
}
",
	}
}

class rsyslog {

	$pkg = "rsyslog"
	$svc = "rsyslog"

	$dir = "/etc/rsyslog.d"
	$magic = $syslog::magic
	$extra_conf = "$dir/00-puppet-sysmgt.conf"

	package { $pkg:
		ensure		=> installed
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
	}

	file { $extra_conf:
		ensure		=> file,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> 644,
		notify		=> Service[$svc],
		content		=> template("syslog/syslog.conf.erb"),
	}

}

class sysklogd {

	$pkg = "sysklogd"
	$svc = "syslog"

	$conf = "/etc/syslog.conf"
	$extra_conf = "/etc/syslog-puppet.conf"

	$magic = $syslog::magic

	package { $pkg:
		ensure		=> installed
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
	}

	file { $extra_conf:
		ensure		=> file,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> 644,
		notify		=> Service[$svc],
		content		=> template("syslog/syslog.conf.erb"),
	}

	exec { "update $conf":
		logoutput	=> true,
		notify		=> Service[$svc],
		require		=> [ Package[$pkg], File[$extra_conf] ],
		unless		=> "grep -q '^$magic' $conf",
		command		=> "cat $extra_conf >> $conf",
	}

}

