#
# puppet class to define ntp server
#
# DONE: Checked for Ubuntu compatibility
#

class ntp::server {

	include ntp

	# disable ntpdate client
	cron_job { $ntp::ntpdate_cron:
		enable	=> "false",
		script	=> "",
	}

	# ensure ntp is installed & running by default
	package { $ntp::ntpd_pkg:
		ensure => installed,
	}

	service { $ntp::ntpd_svc:
		enable		=> true,
		hasrestart	=> true,
		require		=> Package[$ntp::ntpd_pkg],
		subscribe	=> File[$ntp::ntp_conf],
	}

	# create ntpd configuration file from template (requires the server list)
	# localnetworks should be a list of the form:
	#	[ "10.0.0.0 mask 255.255.0.0", "192.168.20.0 mask 255.255.255.0", ]
	# ntp_peers is just a list of strings which are put verbatim into the file.
	define conf( $ntp_peers = $ntp::default_ntp_peers, $localnetworks = [] ) {
		file { $ntp::ntp_conf:
			owner   => root,
			group   => root,
			mode    => 644,
			content => template("ntp/ntp.conf.puppet.erb"),
			require	=> Package[$ntp::ntpd_pkg],
		}
	}

}

