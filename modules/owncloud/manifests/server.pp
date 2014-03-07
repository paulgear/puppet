# puppet class to configure owncloud - assumes use of apt

class owncloud::server (
	$ensure = "present",
	$release,	# e.g. "Debian_7.0", "xUbuntu_12.04", etc.
) {
	class { "owncloud::server::package":
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
	include apache
	include apt
	class { "owncloud::server::repository":
		ensure		=> $ensure,
		release		=> $release,
	}
	package { $pkg:
		ensure		=> installed,
		require		=> [ Class["owncloud::server::repository"], Class["apt::refresh"], Class["apache"], ],
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

