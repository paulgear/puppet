# puppet class to configure postgrey

class postgrey {

	$pkg = "postgrey"
	$svc = "postgrey"

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		require		=> Package[$pkg],
	}

}

