# puppet class to customise syslog

class syslog {

	$dir = "/var/log/sysmgt"
	$rot = "$dir/RotatedLogs"

	$magic = "### puppet syslog configuration - "

	$owner = "root"
	$group = "root"

	$provider = $operatingsystem ? {
		centos		=> "sysklogd",
		ubuntu		=> "rsyslog",
		debian		=> "rsyslog",
	}
	include $provider

}

class syslog::local_files {
	include syslog

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

	define syslog_dir ( $mode = 755 ) {
		file { $name:
			ensure		=> directory,
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

	# create dirs
	syslog_dir { [ "$syslog::dir", "$syslog::rot" ]: }

	# create files
	syslog_file { $files: }
	syslog_file { $priv_files: mode => 640 }

	# logrotate configuration for the local files
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

	${syslog::provider::add_config} { "sysmgt":
		content		=> template("syslog/sysmgt.conf.erb"),
	}

}

define syslog::tty ( $tty = "tty12" ) {
	include syslog
	${syslog::provider::add_config} { "tty":
		content	=> "# Created by puppet on $server - do not edit here
*.info /dev/$tty
",
	}
}

define syslog::remote( $host ) {
	include syslog
	${syslog::provider::add_config} { "remote":
		content => "# Created by puppet on $server - do not edit here
*.info	@$host
",
	}
}

class rsyslog {

	$pkg = "rsyslog"
	$svc = "rsyslog"

	$dir = "/etc/rsyslog.d"

	package { $pkg:
		ensure		=> installed
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
	}

	# note: $name must not contain spaces
	define add_config( $content ) {
		$magic = "$syslog::magic $name"
		file { "$rsyslog::dir/00-puppet-$name.conf":
			ensure		=> file,
			owner		=> "$syslog::owner",
			group		=> "$syslog::group",
			mode		=> 644,
			notify		=> Service["$rsyslog::svc"],
			content		=> "$magic\n$content",
		}
	}

}

class sysklogd {

	$pkg = "sysklogd"
	$svc = "syslog"

	$conf = "/etc/syslog.conf"
	$dir = "/etc/syslog-tmp.d"

	package { $pkg:
		ensure		=> installed
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
	}

	file { $dir:
		ensure		=> directory,
		owner		=> "$syslog::owner",
		group		=> "$syslog::group",
		mode		=> 755,
	}

	define add_config( $content ) {

		$filename = "$sysklogd::dir/00-puppet-$name.conf"
		$magic = "$syslog::magic $name"

		file { $filename:
			ensure		=> file,
			owner		=> "$syslog::owner",
			group		=> "$syslog::group",
			mode		=> 644,
			content		=> $content,
		}

		exec { "update $name":
			logoutput	=> true,
			notify		=> Service["$sysklogd::svc"],
			require		=> [ Package["$sysklogd::pkg"], File[$filename] ],
			unless		=> "grep -q '^$magic' $sysklogd::conf",
			command		=> "echo '$magic' >> $sysklogd::conf && cat $filename >> $sysklogd::conf",
		}

	}

}

