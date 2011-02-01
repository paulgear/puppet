# puppet class to install rrd components

class rrd::package::rrdp {
	$pkg = "librrdp-perl"
	package { $pkg:
		ensure		=> installed,
	}
}

