#
# puppet class to manage bind name servers
#

class bind {

	$pkg = $operatingsystem ? {
		debian		=> "bind9",
		ubuntu		=> "bind9",
		default		=> "bind",
	}
	$svc = $operatingsystem ? {
		debian		=> "bind9",
		ubuntu		=> "bind9",
		default		=> "named",
	}

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

	if $operatingsystem == "CentOS" {
		$mod = "bind"
		$chroot = "/var/named/chroot"

		package { "caching-nameserver":
			ensure	=> installed,
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
	else {
		# No extra setup on Debian & Ubuntu for now
	}

}

