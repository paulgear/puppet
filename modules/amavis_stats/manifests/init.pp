# puppet class to install amavis-stats

class amavis_stats {
	include amavis_stats::package
}

class amavis_stats::package {
	$pkg = "amavis-stats"
	$php5 = "libapache2-mod-php5"
	package { [ $pkg, $php5 ]:
		ensure		=> installed
	}
}

