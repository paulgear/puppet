#
# puppet class to manage snmpd.conf and snmpd service
#
# TODO: other OSes (e.g. Debian) require /etc/{default,sysconfig}/snmpd* to
# be modified to allow snmpd to listen on a non-loopback interface.
#

class snmp {

	$conf = "/etc/snmp/snmpd.conf"
	$defaults = "/etc/default/snmpd"
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
		file { $snmp::conf:
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
		subscribe	=> File[$conf],
		hasrestart	=> true,
	}

	# operating system-specific customisations
	case $operatingsystem {
		debian: {
			case $lsbdistcodename {
				squeeze: {
					# reduce debugging noise in syslog per bug #559109
					# otherwise, snmpd produces lots of errors like this:
					# snmpd[22218]: error on subcontainer 'ia_addr' insert (-1)
					text::replace_lines { "$fqdn-snmpd-$lsbdistcodename-logging":
						file	=> $snmp::conf,
						pattern	=> "-Lsd",
						replace	=> "-Ls6d",
						notify	=> Service[$snmp::svc],
					}
				}
				lenny: {
					# remove the loopback bind from the startup configuration
					text::replace_lines { "$fqdn-snmpd-$lsbdistcodename-startup": 
					    	file	=> $snmp::defaults,
						pattern	=> " 127\.0\.0\.1",
						replace	=> "",
						notify	=> Service[$snmp::svc],
					}
				}
			}
		}
	}

}

