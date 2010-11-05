# Source: http://projects.puppetlabs.com/projects/1/wiki/Resolv_Conf_Patterns
# License: unknown, assumed to be GPLv3 compatible

# Class: resolver
#
# This class handles configuring /etc/resolv.conf
#
# Parameters:
#       $domainname: The default domain
#
#       $searchpath: Array of domains to search
#
#       $nameservers: List of nameservers to search
#
# Actions:
#       Configures the /etc/resolv.conf file according to parameters
#
# Requires:
#
# Sample Usage:
#       resolv_conf { "example":
#                       domainname  => "mydomain",
#                       searchpath  => ['mydomain', 'test.mydomain'],
#                       nameservers => ['192.168.1.100', '192.168.1.101', '192.168.1.102'],
#       }
#

class resolver {

	define config ($domainname = $domain, $searchpath = [ $domain ], $nameservers) {
		file { "/etc/resolv.conf":
			owner	=> root,
			group	=> root,
			mode	=> 644,
			content	=> template("resolver/resolv.conf.erb"),
		}
	}

}
