# puppet class to manage encrypted filesystem setup

class backup::cryptsetup {
	include backup::cryptsetup::files
}

class backup::cryptsetup::files {
	include backup::cryptsetup::package

	ulb { [ "cryptfs-common", "cryptfs-create", "cryptfs-mount", ]:
		source_class	=> "backup",
		require		=> Class["backup::cryptsetup::package"],
	}
	file { "/usr/local/bin/cryptfs-umount":
		ensure		=> link,
		target		=> "/usr/local/bin/cryptfs-mount",
	}
}

class backup::cryptsetup::package {
	$pkg = $operatingsystem ? {
		centos	=> "cryptsetup-luks",
		default	=> "cryptsetup",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

