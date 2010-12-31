# install sasl package
class sasl::package {
	$pkgs = [ "libsasl2-modules", "sasl2-bin", ]
	package { $pkgs:
		ensure		=> installed,
	}
}

