# puppet class to install phpmyadmin

class phpmyadmin {
	include phpmyadmin::package
}

class phpmyadmin::package {
	$pkg = "phpmyadmin"
	package { $pkg:
		ensure	=> installed,
	}
}

