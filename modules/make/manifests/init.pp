# puppet class to install make

class make {
	include make::package
}

class make::package {
	$pkg = "make"
	package { $pkg:
		ensure	=> installed,
	}
}
