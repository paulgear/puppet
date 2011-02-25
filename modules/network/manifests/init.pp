# puppet class to enable dhcp client

class network::dhcp::client {
	include network::dhcp::client::package
	include network::dhcp::client::packagepurge
}

class network::dhcp::client::package {
	$pkg = $operatingsystem ? {
		debian	=> $operatingsystemrelease ? {
			6.0	=> [ "isc-dhcp-client", ],
			5.0	=> [ "dhcp3-client", ],
		},
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class network::dhcp::client::packagepurge {
	$nopkg = $operatingsystem ? {
		debian	=> $operatingsystemrelease ? {
			6.0	=> [ "dhcp3-client", "dhcp3-common", ],
		},
	}
	package { $pkg:
		ensure	=> purged,
		require	=> Class["network::dhcp::client::package"],
	}
}

