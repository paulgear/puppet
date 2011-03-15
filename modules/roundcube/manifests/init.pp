# puppet class to install roundcube webmail

class roundcube {
	include roundcube::package
}

class roundcube::package {
	$pkg = "roundcube"
	package { $pkg:
		ensure	=> installed,
	}
}

