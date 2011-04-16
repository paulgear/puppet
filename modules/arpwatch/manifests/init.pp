# puppet class to install arpwatch

class arpwatch {
	include arpwatch::package
	include arpwatch::service
}

class arpwatch::package {
	$pkg = "arpwatch"
	package { $pkg:
		ensure		=> installed,
	}
}

class arpwatch::service {
	$svc = "arpwatch"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> false,
		require		=> Class["arpwatch::package"],
	}
}

define arpwatch::interface ( $interface = "eth0" ) {
	include arpwatch
	$cfg = "/etc/default/arpwatch"
	$check = "/bin/grep -Ee '^ARGS=.*-i $interface' $cfg"
	exec { "$cfg change interface":
		command		=> "sed -r -i -e '/^ARGS=/s/-i [0-9A-Za-z]+/-i $interface/' $cfg",
		unless		=> $check,
		logoutput	=> true,
	}
	exec { "$cfg add interface":
		command		=> "sed -r -i -e 's/^(ARGS=\".*)\"$/\\1 -i $interface\"/' $cfg",
		unless		=> $check,
		require		=> Exec["$cfg change interface"],
		logoutput	=> true,
	}
}

