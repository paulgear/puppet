#
# puppet module to install logwatch customisations
#

class logwatch {

	package { "logwatch":
		ensure	=> installed,
	}

	define logwatch_dir() {
		file { "/etc/logwatch/$name":
			ensure	=> directory,
			owner	=> root,
			group	=> root,
			recurse	=> true,
			ignore	=> [ ".svn", "*.orig", "*.patch", ],
			source	=> "puppet:///modules/logwatch/$name",
			require	=> Package["logwatch"],
		}
	}

	logwatch_dir{ [ "conf", "scripts" ]: }

	if ($operatingsystem == "Debian" && $lsbmajdistrelease >= 5) {
		file { "/etc/logwatch/scripts/services/clam-update":
			ensure	=> absent,
		}
	}

}

