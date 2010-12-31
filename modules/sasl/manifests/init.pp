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
	# manually enable service on Debian/Ubuntu
	case $operatingsystem {
		debian, ubuntu: {
			text::replace_lines { "/etc/default/saslauthd":
				file		=> "/etc/default/saslauthd",
				pattern		=> "^start=.*",
				replace		=> "start=yes",
				optimise	=> true,
				require		=> Class["sasl::package"],
			}
		}
	}
}

