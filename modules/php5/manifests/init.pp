# puppet class to install php5

class php5 {
	include php5::package
}

class php5::package {
	$pkg = $operatingsystem ? {
		centos	=> "php",
		debian	=> "libapache2-mod-php5",
		ubuntu	=> "libapache2-mod-php5",
	}
	package { $pkg:
		ensure		=> installed,
	}
}

