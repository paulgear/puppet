# puppet class to install mailman

class mailman {
	include mailman::package
	include mailman::service
}

class mailman::package {
	$pkg = "mailman"
	package { $pkg:
		ensure		=> installed,
	}
}

class mailman::service {
	$svc = "mailman"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> $operatingsystem ? {
			debian	=> false,
			ubuntu	=> false,
		}
		require		=> Class["mailman::package"],
	}
}

