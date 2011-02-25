# puppet class to install rsyslog

# Normally it is not necessary to call this class directly.
# It is included automatically by syslog if it is needed.

class rsyslog {
	include rsyslog::package
	include rsyslog::service
}

class rsyslog::package {
	$pkg = "rsyslog"
	package { $pkg:
		ensure		=> installed,
	}
}

class rsyslog::service {
	$svc = "rsyslog"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["rsyslog::package"],
	}
}

