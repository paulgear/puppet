# puppet classes to manage dhcp services

class dhcp::server {

	$pkg = $operatingsystem ? {
		debian	=> "dhcp3-server",
		ubuntu	=> "dhcp3-server",
		centos	=> "dhcp",
	}

	package { $pkg:
		ensure	=> installed,
	}

}

