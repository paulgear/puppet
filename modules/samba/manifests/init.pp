#
# puppet class to install & configure samba
#
# FIXME - Ubuntu: only samba 3.4 is available
#

class samba::base {
	include samba::package
	include samba::service
}

class samba::package {
	$pkg = $sambaver ? {
		"3.4"	=> "samba3",
		default	=> "samba",
	}
	# ensure package is installed
	package { $pkg:
		ensure	=> installed,
	}
}

class samba::service {
	$svc = $operatingsystem ? {
		"CentOS"	=> "smb",
		default		=> "samba",
	}
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["samba::package"],
	}
}

class samba::config {
	$cfg = "/etc/samba/smb.conf"
	file { $cfg:
		ensure		=> file,
		mode		=> 644,
		owner		=> root,
		group		=> root,
		require		=> Class["samba::package"],
		notify		=> Class["samba::service"],
		content		=> template("samba/smb.conf.erb"),
	}
}

