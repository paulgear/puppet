#
# class to manage clamav
#
# DONE: Edited for Ubuntu compatibility
#

class clamav {

	$pkg = $operatingsystem ? {
		centos		=> "clamd",
		ubuntu		=> "clamav-daemon",
		debian		=> "clamav-daemon",
	}
	$pkg_freshclam = $operatingsystem ? {
		centos		=> "clamd",
		ubuntu		=> "clamav-freshclam",
		debian		=> "clamav-freshclam",
	}
	if $pkg != $pkg_freshclam {
		package { $pkg_freshclam: ensure => installed }
	}

	$svc = $operatingsystem ? {
		default		=> $pkg,
	}

	$dir = $operatingsystem ? {
		centos		=> "/etc",
		ubuntu		=> "/etc/clamav",
		debian		=> "/etc/clamav",
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

	package { $pkg:
		ensure		=> installed,
	}

	# these files are managed automatically by the Ubuntu clamav packages
	if $operatingsystem == "CentOS" {

		file { "$dir/clamd.conf":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			source		=> "puppet:///modules/clamav/clamd.conf",
			notify		=> Service[$svc],
		}

		file { "/etc/cron.daily/freshclam":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 755,
			source		=> "puppet:///modules/clamav/freshclam.cron",
			require		=> Package[$pkg_freshclam],
		}

		file { "/etc/logrotate.d/clamav":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			source		=> "puppet:///modules/clamav/clamav.logrotate",
			require		=> Package[$pkg],
		}

		file { "/etc/logrotate.d/freshclam":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			source		=> "puppet:///modules/clamav/freshclam.logrotate",
		}

		file { "/var/clamav":
			ensure		=> directory,
			owner		=> clamav,
			group		=> clamav,
			recurse		=> true,
			ignore		=> "clmilter.socket",
		}

		$remove_files = [ "daily.cld", "daily.cvd.rpmnew", "main.cld", "main.cvd.rpmnew" ]
		define remove_file () {
			file { "/var/clamav/$name":
				ensure		=> absent,
			}
		}
		remove_file { $remove_files: }

	}

}

