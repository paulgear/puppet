# Ubuntu-specific configuration

class os::ubuntu {
	# TODO: add repo management
	include apt
	include isp

	# assume all services have a restart and a status, even if it's not true
	Service {
		hasrestart	=> true,
		hasstatus	=> true,
	}
}

class os::ubuntu::packages {
        $packages = [

            'byobu',
            'lsof',
            'lsscsi',
            'psmisc',
            'screen',
            'strace',
            'tshark',
            'vim',

        ]

	package { $packages:
		ensure	=> installed,
	}

	include etckeeper
	include sysstat
}
