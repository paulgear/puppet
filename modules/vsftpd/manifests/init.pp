# puppet class to configure vsftpd

class vsftpd {
	include vsftpd::package
	include vsftpd::service
}

# install package
class vsftpd::package {
	$pkg = "vsftpd"
	package { $pkg:
		ensure		=> installed,
	}
}

# enable service
class vsftpd::service {
	$svc = "vsftpd"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["vsftpd::package"],
	}
}

