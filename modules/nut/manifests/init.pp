# puppet classes to manage nut

# choose only one of client or server

This is not yet a workable config
Don't expect anything from it

class nut {
	$dir = $operatingsystem ? {
		centos	=> "/etc/ups",
		debian	=> "/etc/nut",
		ubuntu	=> "/etc/nut",
	}
	$group = $operatingsystem ? {
		centos	=> "nut",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	$user = $operatingsystem ? {
		centos	=> "nut",
		debian	=> "root",
		ubuntu	=> "root",
	}
}

class nut::client {
	include nut
	include nut::client::package
	include nut::client::service
}

class nut::server {
	include nut
	include nut::server::package
	include nut::server::service
}

class nut::client::package {
	$pkg = $operatingsystem ? {
		centos	=> "nut-client",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class nut::client::service {
	$svc = $operatingsystem ? {
		centos	=> "ups",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		require		=> Class["nut::client::package"],
	}
}

define nut::client::config (
		$mastername,
		$runasuser,
		$slavename = "monslave",
		$slavepass,
		$upsname
		) {
	include nut::client
	file { "$nut::dir/upsmon.conf":
		ensure	=> file,
		owner	=> $nut::user,
		group	=> $nut::group,
		mode	=> 640,
		content	=> template("nut/upsmon.conf.erb"),
	}
}

class nut::server::package {
	$pkg = $operatingsystem ? {
		centos	=> [ "nut", "nut-client", ],
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class nut::server::service {
	$svc = $operatingsystem ? {
		centos	=> "ups",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
}

define nut::server::config (
		) {
}

