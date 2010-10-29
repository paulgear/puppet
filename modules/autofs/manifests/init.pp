#
# puppet class to manage autofs
#
# DONE: Checked for Ubuntu compatibility
#

class autofs {

	$pkg = "autofs"
	$svc = "autofs"

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

	define autofs( $device = "/dev/sdc1", $fstype = "ext3" ) {

		file { "/etc/auto.master":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			require		=> Package[$autofs::pkg],
			notify		=> Service[$autofs::svc],
			content		=> template("autofs/auto.master.erb"),
		}

		file { "/etc/auto.autofs":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			require		=> [ Package[$autofs::pkg], File["/etc/auto.master"] ],
			notify		=> Service[$autofs::svc],
			content		=> template("autofs/auto.autofs.erb"),
		}

	}

}
