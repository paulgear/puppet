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
		recurse	=> true,
		owner	=> root,
		group	=> root,
		source	=> "puppet:///modules/openvpn/$fqdn",
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
	}
}

define openvpn::client ( $remotes, $remote_random = "false" ) {
	include openvpn
	$cfg = "client.conf"
	$dir = "/etc/openvpn"
	file { "$dir/$cfg":
		mode	=> 644,
		owner	=> root,
		group	=> root,
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
		content	=> template("openvpn/$cfg.erb"),
	}
}

