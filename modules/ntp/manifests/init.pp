#
# puppet class with basic ntp definitions
#
# DONE: Checked for Ubuntu compatibility
#

class ntp {

	$country = "au"

	# set package names appropriately
	case $operatingsystem {
		centos: {
			$ntpdate_pkg = "ntp"
			$ntpd_pkg = "ntp"
			$ntpd_svc = "ntpd"
		}
		default: {
			$ntpdate_pkg = "ntpdate"
			$ntpd_pkg = "ntp"
			$ntpd_svc = "ntp"
		}
	}

	# name of the cron job we use for ntpdate runs
	$ntpdate_cron = "ntpdate"

	# name of the ntp server config file
	$ntp_conf = "/etc/ntp.conf"

	# default peers (for ntp servers)
	$default_ntp_peers = [
		"server 0.$country.pool.ntp.org iburst",
		"server 1.$country.pool.ntp.org iburst",
		"server 2.$country.pool.ntp.org iburst",
		"server 3.$country.pool.ntp.org iburst",
	]

	# default servers (for ntp clients)
	$default_ntp_servers = [
		"0.$country.pool.ntp.org",
		"1.$country.pool.ntp.org",
		"2.$country.pool.ntp.org",
		"3.$country.pool.ntp.org",
	]

	ulb { "ntp-check":
		source_class	=> "ntp",
	}

}

