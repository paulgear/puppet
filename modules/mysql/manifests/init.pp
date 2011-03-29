# puppet class to manage mysql

class mysql::server {
	include mysql::server::package
	include mysql::server::service
}

class mysql::server::package {
	$pkg = "mysql-server"
	package { $pkg:
		ensure	=> installed,
	}
}

class mysql::server::service {
	$svc = $operatingsystem ? {
		centos	=> "mysqld",
		debian	=> "mysql",
		ubuntu	=> "mysql",
	}
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["mysql::server::package"],
	}
}

