# puppet class to install tftpd 

class tftp::server {
	include tftp::server::package
	include tftp::server::service
}

class tftp::server::package {
	$pkg = $operatingsystem ? {
		CentOS	=> "tftp-server",
		default	=> "tftpd",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class tftp::server::service {
	$svc = $operatingsystem ? {
		CentOS	=> "tftp",
		default	=> "tftpd",
	}
	service { $svc:
		enable		=> true,
		require		=> Class["tftp::server::package"],
	}
}

