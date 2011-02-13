# puppet class to install pppoeconf

class network::pppoeconf {
	$pkg = "pppoeconf"
	package { $pkg:
		ensure	=> installed,
	}
}

