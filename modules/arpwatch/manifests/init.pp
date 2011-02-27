# puppet class to install arpwatch

class arpwatch {
	include arpwatch::package
	include arpwatch::service
}

class arpwatch::package {
	$pkg = "arpwatch"
	package { $pkg:
		ensure	=> installed,
	}
}

class arpwatch::service {
	$svc = "arpwatch"
	service { $svc:
		enable		=> true,
		hasstatus	=> false,
		hasrestart	=> true,
		require		=> Class["arpwatch::package"],
	}
}

