# puppet class to install ntop

class ntop {
	include ntop::package
	include ntop::service
}

class ntop::package {
	$pkg = "ntop"
	package { $pkg:
		ensure	=> installed,
	}
}

class ntop::service {
	$svc = "ntop"
	service { $svc:
		enable	=> true,
		require	=> Class["ntop::package"],
	}
}

