# puppet class to install openvpn

class openvpn {

	$pkg = "openvpn"

	package { $pkg:
		ensure	=> installed,
	}

}

