#
# puppet class to reconfigure vmware server on bootup
#
# DONE: Checked for Ubuntu compatibility - do not use
#

class vmware::server {

	include	grub::default

	$pkgs = [ "gcc", "kernel-headers", "kernel-devel" ]

	package { $pkgs:
		ensure	=> installed,
	}

	file { "/etc/init.d/vmware-server-configure":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/vmware/vmware-server-configure.init.sh",
		require	=> Package[ $pkgs ],
	}

	service { "vmware-server-configure":
		enable	=> true,
		require	=> File[ "/etc/init.d/vmware-server-configure" ],
	}

}

