#
# puppet class to manage snmpd.conf and snmpd service
#

class snmp {
	$defaults = "/etc/default/snmpd"

	include snmp::package
	include snmp::service

	# operating system-specific customisations
	case $operatingsystem {
		debian: {
			include snmp::set_debug_level
			include snmp::mibs
		}
		ubuntu: {
			include snmp::mibs
			case $lsbdistcodename {
				lucid: {
					include snmp::no_loopback
				}
			}
		}
	}

}

class snmp::package {
	$pkg = $operatingsystem ? {
		centos		=> "net-snmp",
		ubuntu		=> "snmpd",
		debian		=> "snmpd",
	}
	package { $pkg:
		ensure		=> installed,
	}
}

class snmp::service {
	include snmp::package
	$svc = "snmpd"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> false,
		require		=> Class["snmp::package"],
	}
}

# install snmp mib package
class snmp::mibs {
	package { "snmp-mibs-downloader":
		ensure	=> installed,
	}
	text::replace_lines { "$fqdn-snmpd-$lsbdistcodename-mibs": 
		file	=> $snmp::defaults,
		pattern	=> '^export MIBS= *$',
		replace	=> '#export MIBS=',
		optimise=> 1,
		notify	=> Class["snmp::service"],
		require	=> Class["snmp::package"],
	}
}

# call this with appropriate parameters to define snmpd.conf
define snmp::snmpd_conf(
		$location = "Unknown",
		$contact = "Unknown",
		$snmp_servers = [ "127.0.0.1", ]
		) {
	include snmp::service
	$templatedir = "/etc/puppet/modules/snmp/templates"
	$conf = "/etc/snmp/snmpd.conf"
	file { $conf:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 640,
		content	=> template("snmp/snmpd.conf"),
		notify	=> Class["snmp::service"],
		require	=> Class["snmp::package"],
	}
}

# remove the loopback bind from the startup configuration
class snmp::no_loopback {
	include snmp::service
	text::replace_lines { "$fqdn-snmpd-$lsbdistcodename-startup": 
		file	=> $snmp::defaults,
		pattern	=> '(SNMPDOPTS=.*) 127\.0\.0\.1',
		replace	=> '\1',
		notify	=> Class["snmp::service"],
		require	=> Class["snmp::package"],
	}
}

# reduce debugging noise in syslog per bug #559109
# otherwise, snmpd produces lots of errors like this:
# snmpd[22218]: error on subcontainer 'ia_addr' insert (-1)
class snmp::set_debug_level {
	include snmp::service
	text::replace_lines { "$fqdn-snmpd-$lsbdistcodename-logging":
		file	=> $snmp::defaults,
		pattern	=> '(SNMPDOPTS=.*)-Lsd',
		replace	=> '\1-Ls6d',
		notify	=> Class["snmp::service"],
		require	=> Class["snmp::package"],
	}
}

