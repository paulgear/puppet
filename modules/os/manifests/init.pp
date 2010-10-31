#
# base-level operating system checks for puppet
#
# DONE: Edited for Ubuntu compatibility
#

class os {
    case $operatingsystem {
	"centos": {
	    info( "Operating system distribution for $fqdn is $operatingsystem" )
	    include centos::yumrepo
	    include os::packages::centos
	}
	"ubuntu": {
	    info( "Operating system distribution for $fqdn is $operatingsystem" )
	    include os::packages::ubuntu
	}
	default: {
	    fail( "Puppet configuration not tested with $operatingsystem, failing host $fqdn" )
	}
    }
}

class os::packages::centos {
	$packages = [ 'lsscsi', 'screen', 'strace', 'wireshark', ]

	package { $packages:
		ensure	=> installed,
	}
}

class os::packages::ubuntu {
	$packages = [ 'byobu', 'lsscsi', 'screen', 'strace', 'wireshark', ]

	package { $packages:
		ensure	=> installed,
	}
}
