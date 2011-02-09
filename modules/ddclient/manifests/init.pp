# puppet class to manage ddclient

class ddclient {
	include ddclient::package
	include ddclient::service
}

class ddclient::package {
	$pkg = "ddclient"
	package { $pkg:
		ensure	=> installed,
	}
}

class ddclient::service {
	$svc = "ddclient"
	service { $svc:
		enable	=> true,
		require	=> Class["ddclient::package"],
	}
}

class ddclient::config {
	include ddclient
	$cfg = "/etc/ddclient.conf"
	file { $cfg:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 600,
		content	=> template("ddclient/ddclient.conf.erb"),
		notify	=> Class["ddclient::service"],
		require	=> Class["ddclient::package"],
	}
}

