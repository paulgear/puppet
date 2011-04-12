# puppet class to install freeradius

class freeradius {
	include freeradius::package
	include freeradius::service
}

class freeradius::package {
	$pkgs = [ "freeradius", "freeradius-ldap", "freeradius-mysql", "freeradius-utils" ]
	package { $pkgs:
		ensure	=> installed,
	}
}

class freeradius::service {
	include freeradius::package
	$svc = "freeradius"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["freeradius::package"],
	}
}

