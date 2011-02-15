# puppet classes to manage dhcp services

class dhcp::server {
	include dhcp::server::package
	include dhcp::server::service
}

class dhcp::server::package {
	$pkg = $operatingsystem ? {
		debian	=> $lsbdistcodename ? {
			lenny	=> "dhcp3-server",
			squeeze	=> "isc-dhcp-server",
		},
		ubuntu	=> "dhcp3-server",
		centos	=> "dhcp",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class dhcp::server::service {
	$svc = $operatingsystem ? {
		debian	=> $lsbdistcodename ? {
			lenny	=> "dhcp3-server",
			squeeze	=> "isc-dhcp-server",
		},
		ubuntu	=> "dhcp3-server",
		centos	=> "dhcpd",
	}
	service { $svc:
		enable	=> true,
		require	=> Class["dhcp::server::package"],
	}
}

class dhcp::server::config {
	include dhcp::server
	$cfg = $operatingsystem ? {
		debian	=> $lsbdistcodename ? {
			lenny	=> "/etc/dhcp3/dhcpd.conf",
			squeeze	=> "/etc/dhcp/dhcpd.conf",
		},
		ubuntu	=> "/etc/dhcp3/dhcpd.conf",
		centos	=> "/etc/dhcpd.conf",
	}
	file { $cfg:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> template("dhcp/dhcpd.conf.erb"),
		notify	=> Class["dhcp::server::service"],
		require	=> Class["dhcp::server::package"],
	}
}
