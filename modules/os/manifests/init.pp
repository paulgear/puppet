#
# base-level operating system checks for puppet
#

class os {

	case $operatingsystem {

	    centos: {
		    info( "OS distro for $fqdn is $operatingsystem $operatingsystemrelease ($lsbdistcodename)" )
		    include mail::newaliases
		    include os::centos
		    include os::centos::packages
	    }

	    debian: {
		    info( "OS distro for $fqdn is $operatingsystem $operatingsystemrelease ($lsbdistcodename)" )
		    include mail::newaliases
		    include os::debian
		    include os::debian::packages
	    }

	    ubuntu: {
		    info( "OS distro for $fqdn is $operatingsystem $operatingsystemrelease ($lsbdistcodename)" )
		    include mail::newaliases
		    include os::ubuntu
		    include os::ubuntu::packages
	    }

	    default: {
		    fail( "This puppet configuration not tested with $operatingsystem, failing host $fqdn" )
	    }

	}

}
