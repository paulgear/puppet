#
# Custom scripts for Scalix email system
#
# FIXME - Ubuntu: /var/run/stunnel probably obsolete, /etc/init.d/stunnel probably obsolete
#

class scalix {

	$stunnel_pkg = "stunnel"
	$stunnel_svc = "stunnel"

	package { $stunnel_pkg:
		ensure	=> installed,
	}

	service { $stunnel_svc:
		enable		=> true,
		require		=> [ File[ "/etc/init.d/$stunnel_svc" ], Package[$stunnel_pkg] ],
		hasrestart	=> true,
		hasstatus	=> true,
	}

	# utility scripts
	define bin_file () {
		file { "/usr/local/bin/$name":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 755,
			source	=> "puppet:///modules/scalix/$name",
		}
	}
	$bin_files = [ "add-scalix-user", "add-scalix-users", "add-scalix-users-to-group" ]
	bin_file { $bin_files: }

	# directory for stunnel
	file { "/var/run/$stunnel_pkg":
		ensure	=> directory,
		owner	=> nobody,
		group	=> nobody,
		mode	=> 750,
	}

	# init scripts
	define init_file() {
		file { "/etc/init.d/$name":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 755,
			source	=> "puppet:///modules/scalix/$name.init",
		}
	}
	init_file { $stunnel_svc: }

	# configuration files
	define config_file($source) {
		file { $name:
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			source	=> "puppet:///modules/scalix/$source",
		}
	}

	config_file { "/var/opt/scalix/sx/s/sys/smtpd.cfg":
		source => "smtpd.cfg",
	}

	config_file { "/etc/$stunnel_pkg/$stunnel_pkg.conf":
		source => "$stunnel_pkg.conf",
		notify	=> Service[$stunnel_svc],
	}

}

