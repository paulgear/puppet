# puppet class to install amavis-stats

class amavis_stats {
	include amavis_stats::package
}

class amavis_stats::package {
	$pkg = "amavis-stats"
	package { $pkg:
		ensure		=> installed
	}
}

