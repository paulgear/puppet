# puppet class to install php5

class php5::package {
	$pkg = "libapache2-mod-php5"
	package { $pkg:
		ensure		=> installed,
	}
}

