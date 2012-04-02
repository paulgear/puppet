# puppet class to install open-vm-tools
# tested only on Debian & Ubuntu

class openvm::tools {
	include openvm::tools::package
	include openvm::tools::service
}


class openvm::tools::package {
	$pkgs = [ "open-vm-toolbox", "open-vm-tools" ]
	package { $pkgs:
		ensure	=> installed,
	}
}

class openvm::tools::service {
	$svc = "open-vm-tools"
	service { $svc
		enable	=> true,
	}
}

