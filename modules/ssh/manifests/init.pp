#
# puppet class to manage ssh keys
#
# DONE: Checked for Ubuntu compatibility
#

class ssh {

	# change this for your site
	$storedir = ""

	$pkg = $operatingsystem ? {
		centos	=> [ "openssh-clients", "openssh-server" ],
		default	=> "ssh",
	}
	$svc = $operatingsystem ? {
		centos	=> "sshd",
		default	=> "ssh",
	}

	package { $pkg:
		ensure => installed,
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

	# only do this on your puppet master
	define create_key( $user = "root", $type = "rsa", $storedir = "$ssh::storedir", $bits = 2048
			) {
		exec { "ssh-keygen":
			command		=> "ssh-keygen -C $name -f $storedir/id_$type.$name -N '' -t $type -b $bits -v",
			creates		=> "$storedir/id_$type.$name.pub",
			logoutput	=> on_failure,
			unless		=> "test -f $storedir/id_$type.$name",
		}
	}

	# installs a key from the puppet master to the client
	define authorized_key( $user = "root", $type = "rsa", $storedir = "$ssh:storedir" ) {
		ssh_authorized_key { "$name":
			ensure	=> present,
			key	=> generate("/usr/bin/awk", "{printf \"%s\", \$2}", "$storedir/id_$type.$name.pub"),
			type	=> $type,
			user	=> $user,
		}
	}

}

