# puppet class to manage encrypted filesystem setup

class backup::cryptsetup {
	include backup::cryptsetup::files
}

class backup::cryptsetup::files {
	ulb { [ "cryptfs-create", "cryptfs-mount", ]:
		source_class	=> "backup",
	}
	file { "/usr/local/bin/cryptfs-umount":
		ensure		=> link,
		target		=> "/usr/local/bin/cryptfs-mount",
	}
}

