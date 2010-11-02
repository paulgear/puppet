#
# puppet class to copy samba server data from the central repository via rsync
#
# FIXME - Ubuntu: only samba 3.4 is available
#

class samba::base {

	$packagename = $sambaver ? {
		"3.4"	=> "samba3",
		default	=> "samba",
	}

	# ensure package is installed
	package { $packagename:
		ensure	=> installed,
	}

	# set service name for distro
	$servicename = $operatingsystem ? {
		centos		=> "smb",
		redhat		=> "smb",
		default		=> "samba",
	}

	# ensure service starts on boot
	service { $servicename:
		enable		=> true,
		hasrestart	=> true,
		require		=> Package[$packagename],
	}

}

