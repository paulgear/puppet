# centos-specific configuration

class os::centos {
	include centos::yumrepo
}

class os::centos::packages {
	$packages = [ 'lsscsi', 'screen', 'strace', 'vim', 'wireshark', ]

	package { $packages:
		ensure	=> installed,
	}
}
