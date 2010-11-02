# puppet class to install rsync and enable rsyncd

class rsync {
	
	$pkg = "rsync"
	$svc = "rsync"

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

}
