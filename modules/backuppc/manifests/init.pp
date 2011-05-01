# puppet class to manage backuppc

class backuppc {
	include backuppc::package
	include backuppc::service
}

# install package
class backuppc::package {
	$pkg = "backuppc"
	package { $pkg:
		ensure		=> installed,
	}
}

# enable service
class backuppc::service {
	$svc = "backuppc"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> $operatingsystem ? {
			debian	=> false,
			ubuntu	=> false,
			default	=> undef,
		},
		pattern		=> $operatingsystem ? {
			debian	=> BackupPC,
			ubuntu	=> BackupPC,
			default	=> undef,
		},
		require		=> Class["backuppc::package"],
	}
}

