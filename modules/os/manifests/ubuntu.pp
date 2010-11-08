# Ubuntu-specific configuration

class os::ubuntu {
	# TODO: add repo management
}

class os::ubuntu::packages {
	$packages = [ 'byobu', 'lsscsi', 'screen', 'strace', 'wireshark', ]

	package { $packages:
		ensure	=> installed,
	}

	include etckeeper
	include sysstat

}
