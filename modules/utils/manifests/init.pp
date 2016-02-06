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
		'iptb',
		'maintenance-reboot',
		'ntp-check',
		'randomsleep',
	]
	ulb { $files: source_class => utils }

}

class utils::gethost {
	$files = [
		'allhosts',
		'gethost',
	]
	ulb { $files: source_class => utils }
	include rsync

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

# maintenance reboot
define utils::reboot (
        $dow = "*",
        $day = "*",
        $week = "*",
        $hour = 1,
        $min = 0,
        $rnd = 900,
) {
	include utils
        if ! $dow =~ /^[1-7]$/ {
                fail("Error: day of week must be between 1 and 7")
        }
        if ! $week =~ /^[1-4]$/ {
                fail("Error: week number must be between 1 and 4")
        }
        cron_job { "maintenance-reboot":
                interval        => "d",
                require         => Class["utils"],
                script          => "# Managed by puppet on ${servername} - do not edit here!
# Runs every time that matches; it is up to the script to
# ensure that reboot only occurs on the nominated week.
${min} ${hour} ${day} * ${dow} root /usr/local/bin/maintenance-reboot --week ${week} ${rnd}
",
        }
}
