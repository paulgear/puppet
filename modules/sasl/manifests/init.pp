# puppet class to configure sasl

class sasl {
	include sasl::package
	include sasl::service
}

# install package
class sasl::package {
	$pkgs = [ "libsasl2-modules", "sasl2-bin", ]
	package { $pkgs:
		ensure		=> installed,
	}
}

# enable service
class sasl::service {
	$svc = "saslauthd"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["sasl::package"],
	}
}

