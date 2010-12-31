# puppet class to manage clamav

class clamav {
	include clamav::package
	include clamav::service
	include clamav::centos
}

class clamav::package {
	$pkgs = $operatingsystem ? {
		centos		=> "clamd",
		debian		=> [ "clamav-daemon", "clamav-freshclam", ],
		ubuntu		=> [ "clamav-daemon", "clamav-freshclam", ],
	}
	package { $pkgs:
		ensure		=> installed,
	}
}

class clamav::service {
	$svc = $operatingsystem ? {
		centos		=> "clamd",
		debian		=> "clamav-daemon",
		ubuntu		=> "clamav-daemon",
	}
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["clamav::package"],
	}
}

class clamav::centos {
	# these files are managed automatically on Debian & Ubuntu
	if $operatingsystem == "CentOS" {
		$dir = "/etc"

		file { "$dir/clamd.conf":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			source		=> "puppet:///modules/clamav/clamd.conf",
			notify		=> Class["clamav::service"],
		}

		file { "/etc/cron.daily/freshclam":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 755,
			source		=> "puppet:///modules/clamav/freshclam.cron",
			require		=> Class["clamav::package"],
		}

		file { "/etc/logrotate.d/clamav":
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			source		=> "puppet:///modules/clamav/clamav.logrotate",
			require		=> Class["clamav::package"],
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

