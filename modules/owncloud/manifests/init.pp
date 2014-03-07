# puppet class to configure owncloud - assumes use of apt

class owncloud::server (
	$ensure = "present",
	$release,	# e.g. "Debian 7.0", "xUbuntu_12.04", etc.
) {
	class { "owncloud::server::service":
		ensure		=> $ensure,
		release		=> $release,
	}
}

class owncloud::server::key (
	$ensure,
	$release,
) {
	apt::key { "owncloud-server-$release-key":
		ensure		=> $ensure,
		source		=> "http://download.opensuse.org/repositories/isv:ownCloud:community/$release/Release.key",
	}
}

class owncloud::server::package (
	$pkg = "owncloud",
	$ensure,
	$release,
) {
	class { "owncloud::server::repository":
		ensure		=> $ensure,
		release		=> $release,
	}
	package { $pkg:
		ensure		=> installed,
		require		=> [ Class["owncloud::server::repository"], Class["apt::refresh"], ],
	}
}

class owncloud::server::repository (
	$ensure,
	$release,
) {
	class { "owncloud::server::key":
		ensure		=> $ensure,
		release		=> $release,
	}
	apt::source { "owncloud-server-$release":
		ensure		=> $ensure,
		comment		=> "owncloud server distribution",
		uri		=> "http://download.opensuse.org/repositories/isv:ownCloud:community/$release/",
		distribution	=> "/",
		require 	=> Class["owncloud::server::key"],
	}
}

class owncloud:server:::service (
	$svc = "owncloud",
	$ensure,
	$release,
) {
	class { "owncloud::server::package":
		ensure		=> $ensure,
		release		=> $release,
	}
	service { $svc:
		enable		=> true,
		require		=> Class["owncloud::server::package"],
#		hasrestart	=> true,
#		hasstatus	=> $operatingsystem ? {
#			debian	=> false,
#			ubuntu	=> false,
#			centos	=> true,
#			default	=> undef,
#		},
#		pattern		=> $operatingsystem ? {
#			debian	=> owncloud,
#			ubuntu	=> owncloud,
#			default	=> undef,
#		},
	}
}

