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

