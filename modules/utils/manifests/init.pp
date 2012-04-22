#
# Some basic utilities
#
# This is an icky class - it should be removed
#
# DONE: Edited for Ubuntu compatibility
#

class utils {
	if ($operatingsystem == "CentOS") {

		yumrepo { "epel":
			enabled		=> 1,
			includepkgs	=> absent,
			excludepkgs	=> 'clam*',
			require		=> Package["epel-release"],
		}

		package { "epel-release":
			ensure		=> installed,
		}

		yumrepo { "rpmforge":
			enabled		=> 1,
			includepkgs	=> 'rpmforge-release,clam*,git*,graphviz,ifplugd,memtester*,perl-*,rrdtool*,sarg*',
			require		=> Package["rpmforge-release"],
		}

		package { "rpmforge-release":
			ensure		=> installed,
		}

	}

	# utility scripts
	define ulb_file () {
		file { "/usr/local/bin/$name":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 755,
			source	=> "puppet:///modules/utils/$name",
		}
	}
	ulb_file { [ 'check-kernel-version', 'fix-tun-devices', 'randomsleep', 'upgrade-dansguardian' ]: }

}

