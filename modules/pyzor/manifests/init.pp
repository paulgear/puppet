# puppet class to install pyzor

class pyzor {

	$pkg = "pyzor"

	package { $pkg:
		ensure	=> installed,
	}

}

