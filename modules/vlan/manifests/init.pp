# puppet class to enable vlans on Debian
class vlan {

	package { "vlan":
		ensure	=> installed,
	}

	exec { "echo 8021q >> /etc/modules":
		unless		=> "grep -q '^[ 	]*8021q' /etc/modules",
	}

}
