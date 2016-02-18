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

                'acct',
                'at',
                'bc',
                'bsd-mailx',
                'byobu',
                'bzip2',
                'file',
                'ftp',
                'iftop',
                'iotop',
                'iptraf',
                'less',
                'lsb-release',
                'lsof',
                'lsscsi',
                'ltrace',
                'mlocate',
                'needrestart',
                'netcat-openbsd',
                'openssl',
                'patch',
                'perl',
                'psmisc',
                'screen',
                'strace',
                'telnet',
                'time',
                'tshark',
                'vim',

        ]

	package { $packages:
		ensure	=> installed,
	}

	include etckeeper
	include sysstat
}
