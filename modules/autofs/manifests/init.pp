#
# puppet class to manage autofs
#

class autofs {
	include autofs::package
	include autofs::service
}

class autofs::package {
	$pkg = "autofs"
	package { $pkg:
		ensure		=> installed,
	}
}

class autofs::service {
	$svc = "autofs"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["autofs::package"],
	}
}

define autofs::autofs( $device = "/dev/sdc1", $fstype = "ext4" ) {
	include autofs
	file { "/etc/auto.master":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		require		=> Class["autofs::package"],
		notify		=> Class["autofs::service"],
		content		=> template("autofs/auto.master.erb"),
	}
	file { "/etc/auto.autofs":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		require		=> [ Class["autofs::package"], File["/etc/auto.master"] ],
		notify		=> Class["autofs::service"],
		content		=> template("autofs/auto.autofs.erb"),
	}
}
