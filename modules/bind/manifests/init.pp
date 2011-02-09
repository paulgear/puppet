# puppet class to manage bind name servers

class bind {
	include bind::config
	include bind::package
	include bind::service
}

class bind::config {
	$dir = $operatingsystem ? {
		debian		=> "/etc/bind",
		ubuntu		=> "/etc/bind",
		centos		=> "/var/named/chroot",
	}

	if $operatingsystem == "CentOS" {
		file { "$dir/etc":
			ensure	=> directory,
			owner	=> root,
			group	=> named,
			mode	=> 750,
		}

		# definitions for files in chroot/etc
		$etc_files = [
			"rndc.conf",
			"rndc.key",
			"named.conf",
			"named.slave.zones",
		]
		define named_etc_file () {
			file { "$dir/etc/$name":
				ensure		=> file,
				owner		=> root,
				group		=> named,
				mode		=> 640,
				source		=> "puppet:///modules/bind/$name",
				require		=> Package[$pkg],
				notify		=> Service[$svc],
			}
		}
		named_etc_file { $etc_files: }
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

class bind::setup {
	# generate named.conf.local from fragments
	include concat::setup
	$zones = "${bind::config}::dir/named.conf.local"
	concat { $zones:
		owner	=> bind,
		group	=> bind,
		mode	=> 644,
	}
}

# create concat fragment in the zone file
define bind::zone (
	$zone,
	$type,
	$file,
	$forwarders,
	$masters,
	$order = undef
) {
	include bind
	include bind::setup
	concat::fragment { $zone:
		target	=> "${bind::setup}::zones",
		content	=> template("bind/zone-def.erb"),
		order	=> $order ? {
			default	=> $order,
			undef	=> 10,
		},
	}
}

define bind::master_zone ( $zone = undef, $order = undef ) {
	if $zone == "" {
		$zone = $name
	}
	bind::zone { $zone:
		type		=> "master",
		file		=> "master/$zone",
		zone		=> $zone,
		order		=> $order,
	}
}

define bind::slave_zone ( $zone = undef, $order = undef, $masters ) {
	if $zone == "" {
		$zone = $name
	}
	bind::zone { $name:
		type		=> "slave",
		file		=> "slave/$zone",
		masters		=> $masters,
		zone		=> $zone,
		order		=> $order,
	}
}

define bind::forward_zone ( $zone = undef, $order = undef, $forwarders ) {
	if $zone == "" {
		$zone = $name
	}
	bind::zone { $name:
		type		=> "forward",
		zone		=> $zone,
		forwarders	=> $forwarders,
		order		=> $order,
	}
}

