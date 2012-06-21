#
# puppet class to customise syslog
#
# DONE: Edited for Ubuntu compatibility
#

class syslog {

	$kern_logfile = "/var/log/kernel.log"
	$kern_logdir = "/var/log/kernellogs"
	$kern_logrotate = "/etc/logrotate.d/kernel"
	$mesg_logfile = "/var/log/messages"
	$mail_logfile = "/var/log/maillog"

	$class = $operatingsystem ? {
		centos		=> $operatingsystemrelease ? {
			/^5/	=>	"sysklogd",
			default	=>	"rsyslog",
		},
		ubuntu		=> "rsyslog",
		debian		=> "rsyslog",
	}
	include $class

	file { $kern_logfile:
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
	}

	file { $kern_logdir:
		ensure		=> directory,
		owner		=> root,
		group		=> root,
		mode		=> 750,
	}

	file { $kern_logrotate:
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		require		=> [ File[$kern_logfile], File[$kern_logdir] ],
		content		=> "# Managed by puppet - do not edit here
$kern_logfile {
	rotate 52
	weekly
	dateext
	compress
	delaycompress
	missingok
	notifempty
	olddir $kern_logdir/
}
",
	}

}

class rsyslog {

	$pkg = "rsyslog"
	$svc = "rsyslog"

	$conf = "/etc/rsyslog.conf"
	$rsyslog_dir = "/etc/rsyslog.d"

	package { $pkg:
		ensure		=> installed
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
	}

	file { $rsyslog_dir:
		ensure		=> directory,
		require		=> Package[$pkg],
	}

	text::append_if_no_such_line { $conf:
		file		=> $conf,
		line		=> '$IncludeConfig /etc/rsyslog.d/*.conf',
		require		=> File[$rsyslog_dir],
		notify		=> Service[$svc],
	}

	file { "$rsyslog_dir/00-puppet-kernel.conf":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		notify		=> Service[$svc],
		content		=> "kern.debug	$syslog::kern_logfile\n",
	}

	file { "$rsyslog_dir/00-puppet-maillog.conf":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		notify		=> Service[$svc],
		content		=> "mail.info	-$syslog::mail_logfile\n",
	}

	file { "$rsyslog_dir/00-puppet-messages.conf":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		notify		=> Service[$svc],
		content		=> "*.info;mail.none;news.none;authpriv.none;cron.none;kern.none	-$syslog::mesg_logfile\n",
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
",
	}

}

class sysklogd {

	$pkg = "sysklogd"
	$svc = "syslog"

	$syslog_conf = "/etc/syslog.conf"

	package { $pkg:
		ensure		=> installed
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
	}

	exec { "add kernel log":
		logoutput	=> on_failure,
		notify		=> Service[$svc],
		require		=> Package[$pkg],
		unless		=> "grep -q '^[^#]*kern\\..*$syslog::kern_logfile' $syslog_conf",
		command		=> "echo 'kern.*	$syslog::kern_logfile' >> $syslog_conf",
	}

	exec { "remove kernel from $syslog::mesg_logfile":
		logoutput	=> on_failure,
		notify		=> Service[$svc],
		require		=> Package[$pkg],
		unless		=> "grep -q '^[^#]*kern.none[^#]*$syslog::mesg_logfile' $syslog_conf",
		command		=> "sed -ri -e 's~^([^ 	]*)([ 	]*$syslog::mesg_logfile)~\\1;kern.none\\2~' $syslog_conf",
	}
	$syslog_logrotate = "/etc/logrotate.d/syslog"

	file { $syslog_logrotate:
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		content		=> "# Managed by puppet - do not edit here
/var/log/messages /var/log/secure /var/log/maillog /var/log/spooler /var/log/boot.log /var/log/cron {
	rotate 52
	weekly
	dateext
	compress
	delaycompress
	missingok
	notifempty
	sharedscripts
	postrotate
		/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
		/bin/kill -HUP `cat /var/run/rsyslogd.pid 2> /dev/null` 2> /dev/null || true
	endscript
}
",
	}

}

