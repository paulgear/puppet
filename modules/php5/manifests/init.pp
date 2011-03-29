# puppet class to install php5

class php5::package {
	$pkg = $operatingsystem ? {
		debian	=> "libapache2-mod-php5",
		centos	=> "php",
	}
	package { $pkg:
		ensure		=> installed,
	}
}

