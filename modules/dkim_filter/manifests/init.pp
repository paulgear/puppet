# puppet class to configure dkim-filter

class dkim_filter {
	include dkim_filter::package
	include dkim_filter::service
}

# install package
class dkim_filter::package {
	$pkg = "dkim-filter"
	package { $pkg:
		ensure		=> installed,
	}
}

# enable service
class dkim_filter::service {
	$svc = "dkim-filter"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["dkim_filter::package"],
	}
}

define dkim_filter::config (
		$canonicalization = "relaxed/simple",
		$daemon_opts = "",
		$domain,
		$keyfile = "/etc/postfix/dkim.key",
		$selector,
		$socket = "inet:12345@127.0.0.1",
		$statistics = "/var/run/dkim-filter/dkim-stats",
		$syslog = "yes",
		$umask = "002"
		) {
	include dkim_filter

	# create the config file
	$cfg = "/etc/dkim-filter.conf"
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
Statistics		$statistics
Syslog			$syslog
UMask			$umask
",
		require	=> Class["dkim_filter::package"],
		notify	=> Class["dkim_filter::service"],
	}

	# set the socket in the startup config
	$def = "/etc/default/dkim-filter"
	file { $def:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> "# Managed by puppet - do not edit here
DAEMON_OPTS="$daemon_opts"
SOCKET="$socket"
",
		require	=> Class["dkim_filter::package"],
		notify	=> Class["dkim_filter::service"],
	}
}

