# puppet class to install quagga

class quagga::server {
	include quagga::server::package
	include quagga::server::service
}

class quagga::server::package {
	$pkg = $operatingsystem ? {
		default	=> "quagga",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class quagga::server::service {
	$svc = $operatingsystem ? {
		default	=> "quagga",
	}
	service { $svc:
		enable		=> true,
		require		=> Class["quagga::server::package"],
	}
}

