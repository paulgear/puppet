# puppet class to install roundcube webmail

class roundcube {
	include roundcube::package
	include mysql::client
}

class roundcube::package {
	$pkg = "roundcube"
	package { $pkg:
		ensure	=> installed,
	}
}

