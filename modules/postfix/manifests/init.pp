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

}

