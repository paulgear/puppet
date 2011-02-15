# puppet class to manage bind name servers

class bind {
	include bind::config
	include bind::package
	include bind::service
}

class bind::config {
	include bind::package
	include bind::service

	$dir = $operatingsystem ? {
		debian		=> "/etc/bind",
		ubuntu		=> "/etc/bind",
		centos		=> "/var/named/chroot",
	}
	$group = $operatingsystem ? {
		debian		=> "bind",
		ubuntu		=> "bind",
		centos		=> "named",
	}

	file { "$dir/etc":
		ensure		=> directory,
		owner		=> root,
		group		=> $group,
		mode		=> 2750,
	}

	if $operatingsystem == "CentOS" {
		$etc_files = [
			"rndc.conf",
			"rndc.key",
			"named.conf",
			"named.slave.zones",
		]
		define named_etc_file () {
			include bind::config
			file { "${bind::config::dir}/etc/$name":
				ensure		=> file,
				owner		=> root,
				group		=> "${bind::config::group}",
				mode		=> 640,
				source		=> "puppet:///modules/bind/$name",
				require		=> Class["bind::package"],
				notify		=> Class["bind::service"],
			}
		}
		named_etc_file { $etc_files: }
	}
}

# generate named.conf.options (used on both CentOS & Debian/Ubuntu)
# set arguments to empty string/array to disable them
define bind::config::options (
		$check_names = [ "master fail", "slave warn", "response ignore" ],
		$forward = "first",
		$forwarder_set = "opendns-basic",
		$forwarders = [],
		$global_notify = "no",
		$edns_udp_size = "512",
		$max_udp_size = "512"
		) {
	include bind

	$forwarder_list = $forwarder_set ? {
		"opendns-familyfilter"	=> [ "208.67.222.123", "208.67.220.123" ],
		"opendns-basic"		=> [ "208.67.222.222", "208.67.220.220" ],
		"custom"		=> $forwarders,
		default			=> [],
	}

	$content = template("bind/named.conf.options.erb")
	notice($content)

	file { "${bind::config::dir}/named.conf.options":
		ensure		=> file,
		owner		=> root,
		group		=> "${bind::config::group}",
		content		=> $content,
		require		=> Class["bind::package"],
		notify		=> Class["bind::service"],
	}
}

class bind::package {
	$pkg = $operatingsystem ? {
		debian		=> "bind9",
		ubuntu		=> "bind9",
		centos		=> [ "bind", "caching-nameserver", ],
	}
	package { $pkg:
		ensure		=> installed,
	}
}

class bind::service {
	include bind::package
	$svc = $operatingsystem ? {
		debian		=> "bind9",
		ubuntu		=> "bind9",
		centos		=> "named",
	}
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["bind::package"],
	}
}

# generate named.conf.local from fragments
class bind::setup {
	include concat::setup
	include bind::config
	include bind::service
	$zones = "${bind::config::dir}/named.conf.local"
	concat { $zones:
		owner	=> root,
		group	=> "${bind::config::group}",
		mode	=> 640,
		notify	=> Class["bind::service"],
	}
}

# create zone fragment to be placed in in the zone file
define bind::zone (
	$zone,
	$zonetype,
	$zonefile = "",
	$forwarders = [],
	$masters = [],
	$zone_notify = "",
	$order = ""
) {
	include concat::setup
	include bind::setup
	$content = template("bind/zone-def.erb")
	concat::fragment { $zone:
		target	=> "${bind::setup::zones}",
		content	=> $content,
		order	=> $order ? {
			default	=> $order,
			""	=> 10,
		},
	}
}

define bind::master_zone ( $zone = "", $order = "", $zone_notify = "yes" ) {
	$zonename = $zone ? {
		default	=> $zone,
		""	=> $name,
	}
	bind::zone { $name:
		zonetype	=> "master",
		zonefile	=> "master/$zonename",
		zone		=> $zonename,
		zone_notify	=> $zone_notify,
		order		=> $order,
	}
}

define bind::slave_zone ( $zone = "", $order = "", $masters, $zone_notify = "no" ) {
	$zonename = $zone ? {
		default	=> $zone,
		""	=> $name,
	}
	bind::zone { $name:
		zonetype	=> "slave",
		zonefile	=> "slave/$zonename",
		masters		=> $masters,
		zone		=> $zonename,
		zone_notify	=> $zone_notify,
		order		=> $order,
	}
}

define bind::forward_zone ( $zone = "", $order = "", $forwarders ) {
	$zonename = $zone ? {
		default	=> $zone,
		""	=> $name,
	}
	bind::zone { $name:
		zonetype	=> "forward",
		zone		=> $zonename,
		forwarders	=> $forwarders,
		order		=> $order,
	}
}

