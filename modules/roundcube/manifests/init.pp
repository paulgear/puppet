# puppet class to install roundcube webmail

class roundcube {
	include roundcube::package
	include mysql::client
	include php5::mysql
}

class roundcube::package {
	$pkg = "roundcube"
	package { $pkg:
		ensure	=> installed,
	}
}

