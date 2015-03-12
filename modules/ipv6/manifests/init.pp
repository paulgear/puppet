#
# puppet classes to manage IPv6 interfaces & services
#

## TODO
#class ipv6::dhcp_pd {
#}

## TODO
#class ipv6::radvd {
#}

class ipv6::interface::setup {
	file { "/etc/network/interfaces":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		replace	=> false,	# don't replace file if it was locally modified
		mode	=> "0644",
		content	=> template("ipv6/interfaces.erb"),
		require	=> File["/etc/network/interfaces.d"],
	}
	file { "/etc/network/interfaces.d":
		ensure	=> directory,
		owner	=> root,
		group	=> root,
		mode	=> "0755",
	}
	exec { "ensure interfaces includes source line":
		unless		=> "grep -Ee '^source /etc/network/interfaces.d' /etc/network/interfaces",
		command		=> "echo 'source /etc/network/interfaces.d' >> /etc/network/interfaces",
		require		=> [ File["/etc/network/interfaces"], File["/etc/network/interfaces.d"] ],
	}
}

define ipv6::address (
	$interface = "",
	$address = "",
	$netmask = 64,
	$mode = "static",
	$description = "",
	$ensure = "file",
) {
	include ipv6::interface::setup
	$filename = "/etc/network/interfaces.d/${interface}-${name}.cfg"
	file { $filename:
		ensure		=> $ensure,
		owner		=> root,
		group		=> root,
		mode		=> "0644",
		require		=> Class["ipv6::interface::setup"],
		content		=> template("ipv6/ipv6_address.erb"),
	}
}

class ipv6::setup {
	sysctl::value { 'net.ipv6.conf.default.use_tempaddr': value => 2 }
	$addresses = hiera('ipv6::addresses', {})
	create_resources('ipv6::address', $addresses)
}

