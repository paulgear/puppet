# puppet class to install razor

class razor {

	$pkg = "razor"

	package { $pkg:
		ensure	=> installed,
	}

}

