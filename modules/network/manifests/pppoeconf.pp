# puppet class to install pppoeconf

class pppoeconf {
	$pkg = "pppoeconf"
	package { $pkg:
		ensure	=> installed,
	}
}

