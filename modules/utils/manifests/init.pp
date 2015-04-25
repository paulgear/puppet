#
# Some basic utilities
#
# This is an icky class - it should be removed
#

class utils {
	if ($operatingsystem == "CentOS") {

		yumrepo { "epel":
			enabled		=> 1,
			includepkgs	=> absent,
			exclude		=> 'clam*',
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
	$files = [
		'check-reboot-required',
		'fix-tun-devices',
		'iptb',
		'randomsleep',
		'upgrade-dansguardian',
	]
	ulb { $files: source_class => utils }

}

class utils::gethost {
	$files = [
		'allhosts',
		'gethost',
	]
	ulb { $files: source_class => utils }

	file { "/usr/local/bin/rsyncallhosts":
		ensure	=> link,
		target	=> 'allhosts',
		require	=> Ulb['allhosts'],
	}

	$dirs = [
		'/usr/local/etc/hosts',
		'/var/local/hosts',
	]
	file { $dirs:
		ensure	=> directory,
		mode	=> 750,
		owner	=> root,
		group	=> root,
	}
}

