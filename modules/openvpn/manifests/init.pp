# puppet class to install openvpn

class openvpn {
	include	openvpn::package
	include openvpn::service
}

class openvpn::package {
	$pkg = "openvpn"
	package { $pkg:
		ensure	=> installed,
	}
}

class openvpn::service {
	include openvpn::package
	$svc = "openvpn"
	service { $svc:
		enable	=> true,
		require	=> Class["openvpn::package"],
	}
}

class openvpn::config {
	include openvpn
	$dir = "/etc/openvpn"
	file { $dir:
		ensure	=> directory,
		owner	=> root,
		group	=> root,
		require	=> Class["openvpn::package"],
	}
	file { "$dir/client.crt":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		source	=> "puppet:///modules/openvpn/$fqdn.crt",
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
	}
	file { "$dir/client.key":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 600,
		source	=> "puppet:///modules/openvpn/$fqdn.key",
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
	}
	file { "$dir/ca.crt":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		source	=> "puppet:///modules/openvpn/ca.crt",
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
	}
}

class openvpn::pingtest {
	include openvpn::service
	ulb { [ "openvpn-status", "pingtest" ]:
		source_class	=> "openvpn",
		require		=> Class["openvpn::service"],
	}
	cron_job { "openvpn-pingtest":
		interval	=> "d",
		script		=> "# Managed by puppet on $servername - do not edit here
*/10 * * * * root /usr/local/bin/pingtest
",
	}
}

define openvpn::client ( $cfgname = "client", $remotes, $remote_random = "false" ) {
	include openvpn
	$cfg = "$cfgname.conf"
	$dir = "/etc/openvpn"
	file { "$dir/$cfg":
		ensure	=> file,
		mode	=> 640,
		owner	=> root,
		group	=> root,
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
		content	=> template("openvpn/$cfg.erb"),
	}
}

