# puppet class to install xen

class xen {

	#include xen::xend
	#include xen::libvirt
	#include xen::virtualmin

	$pkgs = $lsbdistcodename ? {
		squeeze		=> [
			"linux-image-xen-$architecture",
			"xen-hypervisor-4.0-$architecture",
			"xen-tools",
		],
		wheezy		=> [
			"linux-image-$architecture",
			"xen-hypervisor-4.1-$architecture",
			"xen-tools",
		],
		jessie		=> [
			"linux-image-$architecture",
			"xen-hypervisor-4.4-$architecture",
			"xen-tools",
		],
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
			"libvirt0/$lsbdistcodename-backports",
			"libvirt-bin/$lsbdistcodename-backports",
			"python-libvirt/$lsbdistcodename-backports",
			"virtinst/$lsbdistcodename-backports",
			"virt-manager/$lsbdistcodename-backports",
		],
		default	=> [
			"libvirt-bin",
			"virt-manager",
		],
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

