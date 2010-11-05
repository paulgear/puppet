# puppet class to enable vlans on Debian
class vlan {

	package { "vlan":
		ensure	=> installed,
	}

	exec { "echo 8021q >> /etc/modules":
		logoutput	=> on_failure,
		unless		=> "grep -q '^[ 	]*8021q' /etc/modules",
	}

}
