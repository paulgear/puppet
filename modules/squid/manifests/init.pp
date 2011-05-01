#
# puppet class to manage squid.conf and nopasswordsites.txt
#

class squid {
	# directory on the puppet server where configurations are kept
	$squiddir = "/etc/puppet/modules/squid"

	# exec used to soft-reload squid
	$reload = "squid-reload"

	$pkg = "squid"
	$svc = "squid"

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

	$owner = $operatingsystem ? {
		ubuntu		=> "proxy",
		debian		=> "proxy",
		default		=> "squid",
	}

	$group = $operatingsystem ? {
		ubuntu		=> "proxy",
		debian		=> "proxy",
		default		=> "squid",
	}

	# call this with appropriate parameters to define squid.conf
	define squid_conf(
			$basic_auth = "on",
			$transparent_port = "0",
			$cache_size = "256",
			$emulate_httpd_log = "on",
			$local_networks = [ "192.168.0.0/255.255.0.0" ],
			$squiddir = "/etc/puppet/modules/squid",
			$visible_hostname = $fqdn
				) {
		file { "/etc/squid/squid.conf":
			ensure	=> file,
			owner	=> root,
			group	=> $squid::group,
			mode	=> 640,
			content	=> template("squid/squid.conf/MASTER.erb"),
			notify	=> Exec[$squid::reload],
			require	=> Package[$squid::pkg],
		}
	}

	# squid's no password url regex file
	file { "/etc/squid/nopasswordsites.txt":
		ensure	=> file,
		owner	=> root,
		group	=> $squid::group,
		mode	=> 640,
		notify	=> Exec[$squid::reload],
		content	=> template("squid/nopasswordsites/MASTER.erb"),
	}

	# squid swap state file
	file { "/var/spool/squid/swap.state":
		ensure	=> file,
		owner	=> $owner,
		group	=> $squid::group,
		mode	=> 640,
	}

	# squid password file
	file { "/etc/squid/squid_passwd":
		ensure	=> file,
		owner	=> root,
		group	=> $squid::group,
		mode	=> 640,
		notify	=> Exec[$squid::reload],
		source	=> "puppet:///modules/squid/squid_passwd",
	}

	# reload squid when the configuration file changes
	exec { $reload:
		command		=> "/usr/sbin/squid -k reconfigure",
		logoutput	=> true,
		refreshonly	=> true,
		require		=> Package[$pkg],
	}

	# logfile rotation
	file { "/etc/logrotate.d/squid":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		require		=> Package[$pkg],
		source		=> "puppet:///modules/squid/squid.logrotate",
	}

}

