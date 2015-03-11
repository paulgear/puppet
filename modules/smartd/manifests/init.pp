# puppet class to manage smartd/smartmontools

class smartd {
	include smartd::package
	include smartd::service
}

# rudimentary smartd.conf
class smartd::config {
	include smartd
	exec { "backup smartd.conf":
		command		=> "cp -a /etc/smartd.conf /etc/smartd.conf.pre-puppet",
		creates		=> "/etc/smartd.conf.pre-puppet",
		require		=> Class["smartd::package"],
	}
	file { "/etc/smartd.conf":
		notify		=> Class["smartd::service"],
		require		=> Exec["backup smartd.conf"],
		mode		=> 644,
		owner		=> root,
		group		=> root,
		content		=> "# managed by puppet - do not edit here
# See /etc/smartd.conf.pre-puppet for original
DEVICESCAN -H -m root
",
	}
}

class smartd::package {
	$pkg = "smartmontools"
	package { $pkg:
		ensure		=> installed,
	}
}

class smartd::service {
	$svc = $operatingsystem ? {
		"centos"	=> "smartd",
		"redhat"	=> "smartd",
		default		=> "smartmontools",
	}
	service { $svc:
		enable		=> true,
		require		=> Class["smartd::package"],
	}
}

