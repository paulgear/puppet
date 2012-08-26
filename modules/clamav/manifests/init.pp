# puppet class to manage clamav

class clamav {
	include clamav::package
	include clamav::service
	include clamav::centos
}

class clamav::package {
	if $operatingsystem == "CentOS" {
		include utils
	}
	$pkgs = $operatingsystem ? {
		centos		=> "clamd",
		debian		=> [ "clamav-daemon", "clamav-freshclam", ],
		ubuntu		=> [ "clamav-daemon", "clamav-freshclam", ],
	}
	package { $pkgs:
		ensure		=> installed,
		require		=> $operatingsystem ? {
			CentOS	=> Class["utils"],
			default	=> undef,
		}
	}
}

class clamav::service {
	$svcs = $operatingsystem ? {
		centos		=> "clamd",
		debian		=> [ "clamav-daemon", "clamav-freshclam", ],
		ubuntu		=> [ "clamav-daemon", "clamav-freshclam", ],
	}
	service { $svcs:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["clamav::package"],
	}
}

define clamav::remove_file () {
	file { "/var/clamav/$name":
		ensure		=> absent,
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
			require		=> Class["clamav::package"],
		}

		file { "/var/clamav":
			ensure		=> directory,
			owner		=> clamav,
			group		=> clamav,
			recurse		=> true,
			ignore		=> "clmilter.socket",
			require		=> Class["clamav::package"],
		}

		$remove_files = [ "daily.cld", "daily.cvd.rpmnew", "main.cld", "main.cvd.rpmnew" ]
		clamav::remove_file { $remove_files: }

	}

}

# Configure freshclam proxy settings
# Note that the service notify is a little ham-fisted - it really should restart
# only freshclam, not clamd as well.
define clamav::freshclam_config (
		$httpproxyserver = "proxy",
		$httpproxyport = "8080"
		) {
	$cfg = "/etc/clamav/freshclam.conf"
	text::replace_add_line { "$cfg HTTPProxyPort":
		file		=> $cfg,
		pattern		=> '^HTTPProxyPort.*',
		line		=> "HTTPProxyPort $httpproxyport",
		notify		=> Class["clamav::service"],
	}
	text::replace_add_line { "$cfg HTTPProxyServer":
		file		=> $cfg,
		pattern		=> '^HTTPProxyServer.*',
		line		=> "HTTPProxyServer $httpproxyserver",
		notify		=> Class["clamav::service"],
	}
}

