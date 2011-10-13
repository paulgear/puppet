#
# puppet class to create ntp client via ntpdate
#
# DONE: Checked for Ubuntu compatibility
#

class ntp::client {

	include ntp

	# install ntpdate command, ensure ntp server is not running
	package { $ntp::ntpdate_pkg:
		ensure	=> installed,
	}
	service { $ntp::ntpd_pkg:
		ensure	=> stopped,
		enabled	=> false,
	}

	define cron( $minutes = 5, $ntp_servers = $ntp::default_ntp_servers ) {
		# create cron job to run ntpdate
		cron_job { $ntp::ntpdate_cron:
			interval	=> "d",
			script		=> template("ntp/cron.d-ntpdate.erb"),
			require		=> Package[$ntp::ntpdate_pkg],
		}
	}

}
