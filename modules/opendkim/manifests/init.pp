# puppet class to configure opendkim

class opendkim {
	include opendkim::package
	include opendkim::service
}

# install package
class opendkim::package {
	$pkg = "opendkim"
	package { $pkg:
		ensure		=> installed,
	}
}

# enable service
class opendkim::service {
	$svc = "opendkim"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["opendkim::package"],
	}
}

define opendkim::config (
		$canonicalization = "relaxed/simple",
		$daemon_opts = "",
		$domain,
		$keyfile = "/etc/postfix/dkim.key",
		$selector,
		$socket = "inet:12345@127.0.0.1",
		$syslog = "yes",
		$umask = "002"
		) {
	include opendkim

	# create the config file
	$cfg = "/etc/opendkim.conf"
	file { $cfg:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> "# Managed by puppet - do not edit here
Canonicalization	$canonicalization
Domain			$domain
KeyFile			$keyfile
Selector		$selector
Syslog			$syslog
UMask			$umask
",
		require	=> Class["opendkim::package"],
		notify	=> Class["opendkim::service"],
	}

	# set the socket in the startup config
	$def = "/etc/default/opendkim"
	file { $def:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> "# Managed by puppet - do not edit here
DAEMON_OPTS=\"$daemon_opts\"
SOCKET=\"$socket\"
",
		require	=> Class["opendkim::package"],
		notify	=> Class["opendkim::service"],
	}
}

