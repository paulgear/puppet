# puppet class to configure dovecot

class dovecot {
	include dovecot::package
	include dovecot::service
}

# install package
class dovecot::package {
	$pkg = "dovecot"
	package { $pkg:
		ensure		=> installed,
	}
}

# enable service
class dovecot::service {
	$svc = "dovecot"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["dovecot::package"],
	}
}

