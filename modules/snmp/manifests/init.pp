#
# puppet class to manage snmpd.conf and snmpd service
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

	# ensure package is installed
	package { $pkg: ensure => installed }

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
					include snmp::set_debug_level
				}
				lenny: {
					include snmp::no_loopback
				}
			}
		}
		ubuntu: {
			case $lsbdistcodename {
				lucid: {
					include snmp::no_loopback
				}
			}
		}
	}

}

# call this with appropriate parameters to define snmpd.conf
define snmp::snmpd_conf(
		$location = "Unknown",
		$contact = "Unknown",
		$snmp_servers = [ "127.0.0.1", ]
		) {
	include snmp
	$templatedir = "/etc/puppet/modules/snmp/templates"
	file { $snmp::conf:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 640,
		content	=> template("snmp/snmpd.conf"),
		require	=> Package[$snmp::pkg],
	}
}

# remove the loopback bind from the startup configuration
class snmp::no_loopback {
	text::replace_lines { "$fqdn-snmpd-$lsbdistcodename-startup": 
		file	=> $snmp::defaults,
		pattern	=> '(SNMPDOPTS=.*) 127\.0\.0\.1',
		replace	=> '\1',
		notify	=> Service[$snmp::svc],
	}
}

# reduce debugging noise in syslog per bug #559109
# otherwise, snmpd produces lots of errors like this:
# snmpd[22218]: error on subcontainer 'ia_addr' insert (-1)
class snmp::set_debug_level {
	text::replace_lines { "$fqdn-snmpd-$lsbdistcodename-logging":
		file	=> $snmp::defaults,
		pattern	=> "-Lsd",
		replace	=> "-Ls6d",
		notify	=> Service[$snmp::svc],
	}
}

