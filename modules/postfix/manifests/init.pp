# puppet class to configure postfix

class postfix {

	$pkg = "postfix"
	$svc = "postfix"

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		require		=> Package[$pkg],
	}

	# packages to remove
	$removepackages = [

		"exim4",
		"exim4-base",
		"exim4-config",
		"exim4-daemon-light",

	]
	package { $removepackages:
		ensure	=> purged,
		require	=> Package[$pkg],
	}

}

