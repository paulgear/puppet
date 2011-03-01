# puppet class to install sysklogd

# Normally it is not necessary to call this class directly.
# It is included automatically by syslog if it is needed.

class sysklogd {
	include sysklogd::package
	include sysklogd::service
	include sysklogd::exec
}

class sysklogd::package {
	$pkg = "sysklogd"
	package { $pkg:
		ensure		=> installed,
	}
}

class sysklogd::service {
	$svc = "syslog"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["sysklogd::package"],
	}
}

class sysklogd::exec {
	include syslog
	$conf = "/etc/syslog.conf"
	$magic = "### puppet syslog configuration -"
	exec { "update $conf":
		logoutput	=> true,
		refreshonly	=> true,
		notify		=> Class["sysklogd::service"],
		require		=> Class["sysklogd::package"],
		command		=> "sed -e '/$magic BEGIN/,/$magic END/d' $conf && (echo '$magic BEGIN'; cat ${syslog::confdir}/*; echo '$magic END') >> $conf",
	}
}

