# puppet class to install quagga

class quagga {
	include quagga::package
	include quagga::service
}

class quagga::package {
	$pkg = $operatingsystem ? {
		default	=> "quagga",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class quagga::service {
	$svc = $operatingsystem ? {
		debian	=> "quagga",
		default	=> "zebra",
	}
	service { $svc:
		enable		=> true,
		require		=> Class["quagga::package"],
	}
}

