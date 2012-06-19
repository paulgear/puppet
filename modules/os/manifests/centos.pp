# centos-specific configuration

class os::centos {
	include centos::yumrepo

	# assume all services have a restart and a status
	Service {
		hasrestart	=> true,
		hasstatus	=> true,
	}
}

class os::centos::packages {
	$packages = [ 'lsscsi', 'screen', 'strace', 'vim-enhanced', 'wireshark', ]

	package { $packages:
		ensure	=> installed,
	}
}

define os::centos::initstyle ( $style = "color" ) {
	include text
	$file = "/etc/sysconfig/init"
	text::replace_add_line { $file:
		file	=> $file,
		pattern => "^BOOTUP=",
		line	=> "BOOTUP=$style",
	}
}

