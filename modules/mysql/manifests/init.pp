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

class mysql::server::scripts {
	$script = "/usr/local/bin/mysql-dumpall"
	file { $script:
		ensure		=> file,
		mode		=> 755,
		owner		=> root,
		group		=> root,
		source		=> "puppet:///modules/mysql/mysql-dumpall",
	}
	cron_job { "mysql-dumpall":
		interval	=> "daily",
		script		=> "#!/bin/sh
$script
",
	}
}

class mysql::client {
	include mysql::client::package
}

class mysql::client::package {
	$pkg = "mysql-client"
	package { $pkg:
		ensure	=> installed,
	}
}

