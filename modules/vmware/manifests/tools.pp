#
# puppet class to reconfigure vmware tools on bootup
#
# DONE: Checked for Ubuntu compatibility
#

class vmware::tools {

	if $operatingsystem == "centos" {

		include	grub::default

		$pkgs = $operatingsystem ? {
			centos	=> [ "gcc", "kernel-headers", "kernel-devel", ],
			ubuntu	=> [ "build-essential", "linux-headers-server", "linux-source", ],
			debian	=> [ "build-essential", "linux-headers-2.6", ],
		}

		package { $pkgs:
			ensure	=> installed,
		}

		file { "/etc/init.d/vmware-tools-configure":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 755,
			source	=> "puppet:///modules/vmware/vmware-tools-configure.init.sh",
			require	=> Package[ $pkgs ],
		}

		service { "vmware-tools-configure":
			enable	=> true,
			require	=> File[ "/etc/init.d/vmware-tools-configure" ],
		}

	}

}

