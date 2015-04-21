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
		command		=> "echo 'source /etc/network/interfaces.d/*.cfg' >> /etc/network/interfaces",
		require		=> [ File["/etc/network/interfaces"], File["/etc/network/interfaces.d"] ],
	}
}

define ipv6::address (
	$interface,
	$address = "",
	$prefix = "",
	$subnet = "",
	$servicegroup = "",
	$node = "",
	$netmask = 64,
	$mode = "auto",
	$description = "",
	$privext = "2",
	$ensure = "file",
	$subnets,		# these are expected to be defined in defaults
	$servicegroups,
) {
	include ipv6::interface::setup
	$filename = "/etc/network/interfaces.d/${interface}-${name}.cfg"
	if $address == "" and $mode == "static" {
	    $subnetnum = $subnets[$subnet]
	    if $servicegroup == "" {
		$address = "${prefix}${subnetnum}::${node}"
	    }
	    else {
		$servicegroupnum = $servicegroups[$servicegroup]
		$address = "${prefix}${subnetnum}::${servicegroupnum}:${node}"
	    }
	}
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
	$catalog = hiera('ipv6::address', {})
	$defaults = $catalog['defaults']
	create_resources('ipv6::address', $catalog['hosts'][$fqdn], $defaults)
}

