# puppet class to install php5

class php5 {
	include php5::package
}

class php5::package {
	include apache
	$pkg = $operatingsystem ? {
		centos	=> "php",
		debian	=> [ "libapache2-mod-php5", "php5-cli" ],
		ubuntu	=> [ "libapache2-mod-php5", "php5-cli" ],
	}
	package { $pkg:
		ensure		=> installed,
		notify		=> Class["apache::service"],
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
		notify		=> Class["apache::service"],
	}
}

class php5::mcrypt {
	include php5
	package { "php5-mcrypt":
		ensure		=> installed,
		notify		=> Exec["php5::mcrypt::enable"],
	}
	exec { "php5::mcrypt::enable":
		command		=> "php5enmod mcrypt",
		refreshonly	=> true,
		notify		=> Class["apache::service"],
	}
}
