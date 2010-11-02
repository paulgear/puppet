#
# puppet class to manage snmpd.conf and snmpd service
#
# TODO: other OSes (e.g. Debian) require /etc/{default,sysconfig}/snmpd* to
# be modified to allow snmpd to listen on a non-loopback interface.
#

class snmp {

	$svc = "snmpd"
	$pkg = $operatingsystem ? {
		centos		=> "net-snmp",
		ubuntu		=> "snmpd",
		debian		=> "snmpd",
	}
	$servers = [ "127.0.0.1", ]

	# ensure package is installed
	package { $pkg: ensure => installed }

	# call this with appropriate parameters to define snmpd.conf
	define snmpd_conf(
			$location = "Unknown",
			$contact = "Unknown",
			$snmp_servers = $snmp::servers
			) {
		# configuration file
		file { "/etc/snmp/snmpd.conf":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			content	=> template("snmp/snmpd.conf"),
			require	=> Package[$snmp::pkg],
		}
	}

	# reload snmp when the configuration file changes
	service { $svc:
		enable		=> true,
		require		=> Package[$pkg],
		subscribe	=> File["/etc/snmp/snmpd.conf"],
		hasrestart	=> true,
	}

}

