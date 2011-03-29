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

class php5::mysql {
	include php5::mysql::package
}

class php5::mysql::package {
	include php5::package
	$pkg = $operatingsystem ? {
		centos	=> "php-mysql",
		debian	=> "php5-mysql",
		ubuntu	=> "php5-mysql",
	}
	package { $pkg:
		ensure		=> installed,
		require		=> Class["php5::package"],
	}
}


