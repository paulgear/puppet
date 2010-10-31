#
# puppet class to manage bind name servers
#
# FIXME - Ubuntu: package, module, and configuration file names
#

class bind {

	$pkg = "bind"
	$svc = "named"
	$mod = "bind"

	$chroot = "/var/named/chroot"

	package { [ $pkg, "caching-nameserver" ]:
		ensure	=> installed,
	}

	service { "$svc":
		enable		=> true,
		hasstatus	=> true,
		hasrestart	=> true,
	}

	file { "$chroot/etc":
		ensure	=> directory,
		owner	=> root,
		group	=> named,
		mode	=> 750,
	}

	# definitions for files in chroot/etc
	$etc_files = [
		"rndc.conf",
		"rndc.key",
		"named.conf",
		"named.slave.zones",
	]
	define named_etc_file () {
		file { "$chroot/etc/$name":
			ensure		=> file,
			owner		=> root,
			group		=> named,
			mode		=> 640,
			source		=> "puppet:///modules/$mod/$name",
			require		=> Package[$pkg],
			notify		=> Service[$svc],
		}
	}
	named_etc_file { $etc_files: }

}

