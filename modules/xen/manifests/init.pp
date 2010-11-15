# puppet class to install xen

class xen {

	include xen::xend
	include xen::libvirt
	include xen::virtualmin

	$pkgs = $lsbdistcodename ? {
		lenny		=> [ "linux-image-xen-amd64", "xen-hypervisor-3.2-1-amd64" ],
		squeeze		=> [ "xen-hypervisor-3.4-amd64" ],
	}

	package { $pkgs:
		ensure		=> installed,
	}

}

class xen::xend {

	$pkg = "xen-utils-common"
	$svc = "xend"

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		require		=> Package[$pkg],
	}

	file { "/etc/xen/xend-config.sxp":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		source		=> "puppet:///modules/xen/xend-config.sxp",
		notify		=> Service[$svc],
		require		=> Package[$pkg],
	}

}

class xen::libvirt {

	$pkgs = $lsbdistcodename ? {
		lenny	=> [
			"libvirt-bin/$lsbdistcodename-backports",
			"virt-manager/$lsbdistcodename-backports",
		],
		default	=> [ "libvirt-bin", "virt-manager", ],
	}
	$pkg = $lsbdistcodename ? {
		lenny	=> "libvirt-bin/$lsbdistcodename-backports",
		default	=> "libvirt-bin",
	}

	package { $pkgs:
		ensure		=> installed,
	}

	service { "libvirt-bin":
		enable		=> true,
		require		=> Package[$pkg],
	}

}

class xen::virtualmin {
	
	require webmin

	$pkg = "virtualmin"

	package { $pkg:
		ensure		=> installed,
		require		=> Package["webmin"],
	}

}

