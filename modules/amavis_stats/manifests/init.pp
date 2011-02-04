# puppet class to install amavis-stats

class amavis_stats {
	include amavis_stats::package
}

class amavis_stats::package {
	include php5::package
	include rrd::package::rrdp
	$pkg = "amavis-stats"
	package { $pkg:
		ensure		=> installed,
		require		=> [ Class["php5::package"], Class["rrd::package::rrdp"] ],
	}

	# add symlink for missing file on Ubuntu 10.04 LTS
	if $operatingsystem == "Ubuntu" {
		file { "/etc/amavis-stats.conf":
			ensure	=> "/etc/amavis-stats/amavis-stats.conf",
		}
	}

}

