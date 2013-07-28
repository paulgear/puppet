# puppet classes to manage dhcp services

class dhcp::server {
	include dhcp::server::package
	include dhcp::server::service
}

class dhcp::server::package {
	$pkg = $operatingsystem ? {
		debian	=> "isc-dhcp-server",
		ubuntu	=> "dhcp3-server",
		centos	=> "dhcp",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class dhcp::server::service {
	$svc = $operatingsystem ? {
		debian	=> "dhcp3-server",
		ubuntu	=> "dhcp3-server",
		centos	=> "dhcpd",
	}
	service { $svc:
		enable	=> true,
		hasstatus => false,
		hasrestart => false,
		require	=> Class["dhcp::server::package"],
	}
}

class dhcp::server::restarter {
	include dhcp::server
	ulb { "dhcpd-check-restart":
		source_class	=> "dhcp",
	}
	cron_job { "dhcpd-check-restart":
		interval	=> "d",
		script		=> "# Managed by puppet on $servername - do not edit here
* * * * * root /usr/local/bin/dhcpd-check-restart
",
	}
}

class dhcp::server::config {
	include dhcp::server
	$cfg = $operatingsystem ? {
		debian	=> "/etc/dhcp/dhcpd.conf",
		ubuntu	=> "/etc/dhcp3/dhcpd.conf",
		centos	=> "/etc/dhcpd.conf",
	}
	$templatedir = "/etc/puppet/modules/dhcp/templates"
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

