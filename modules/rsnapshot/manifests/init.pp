# puppet class to install rsnapshot

class rsnapshot {
	include rsnapshot::package
}

class rsnapshot::package {
	$pkg = "rsnapshot"
	package { $pkg:
		ensure	=> installed,
	}
}

