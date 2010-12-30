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
		$domain,
		$keyfile = "/etc/postfix/dkim.key",
		$selector,
		$statistics = "/var/run/dkim-filter/dkim-stats",
		$syslog = "yes",
		$umask = "002"
		) {
	include dkim_filter
	$file = "/etc/dkim-filter.conf"
	file { $file:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mod	=> 644,
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
}

