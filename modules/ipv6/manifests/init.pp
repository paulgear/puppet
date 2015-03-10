#
# puppet class to create network interface definitions for IPv6 services
#

class ipv6::dhcp_pd {
}

class ipv6::radvd {
}

class ipv6::interface::setup {
	file { "/etc/network/interfaces":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		replace => false,
		mode	=> 644,
		content	=> template("network/interfaces.erb"),
		require => File["/etc/network/interfaces.d"],
	}
	file { "/etc/network/interfaces.d":
		ensure	=> directory,
		owner	=> root,
		group	=> root,
		mode	=> 755,
	}
	exec { "ensure interfaces includes source line":
		unless		=> "grep -Ee '^source /etc/network/interfaces.d' /etc/network/interfaces",
		exec		=> "echo 'source /etc/network/interfaces.d' >> /etc/network/interfaces",
		logoutput	=> on_failure,
		require		=> [ File["/etc/network/interfaces"], File["/etc/network/interfaces.d"] ],
	}
}

class ipv6::address (
	$interface,
	$address = "",
	$netmask = 64,
	$mode = "static",
	$description = "",
	$ensure = file,
) {
	include ipv6::interface::setup
	file { "/etc/network/interfaces.d/$interface-$name.cfg":
		ensure	=> $ensure,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require => Class["ipv6::interface::setup"],
		content => template("network/ipv6_address.erb"),
	}
}

