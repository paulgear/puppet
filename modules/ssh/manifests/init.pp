# puppet class to manage ssh

class ssh {

	# change this for your site
	$storedir = ""

	include ssh::package
	include ssh::service

	# include this only once on your puppetmaster
	define storedir( $storedir = "$ssh::storedir" ) {
		file { $storedir:
			ensure		=> directory,
			owner		=> "puppet",
			recurse		=> true,
		}
	}

	# only do this on your puppet master
	define create_key( $user = "root", $type = "rsa", $storedir = "$ssh::storedir", $bits = 2048
			) {
		exec { "ssh-keygen-$name":
			command		=> "ssh-keygen -C $name -f $storedir/id_$type.$name -N '' -t $type -b $bits -v",
			creates		=> "$storedir/id_$type.$name.pub",
			logoutput	=> on_failure,
			unless		=> "test -f $storedir/id_$type.$name",
		}
		file { "$storedir/id_$type.$name":
			ensure		=> file,
			owner		=> puppet,
			mode		=> 640,
			require		=> [ File[ $storedir ], Exec[ "ssh-keygen-$name" ], ],
		}
	}

	# installs an authorized key from the puppet master to the client
	define authorized_key(
			$ensure = "present",
			$user = "root",
			$type = "rsa",
			$storedir = "$ssh::storedir",
			$options = undef
				) {
		ssh_authorized_key { "$name":
			ensure	=> $ensure,
			key	=> generate("/usr/bin/awk", "{printf \"%s\", \$2}", "$storedir/id_$type.$name.pub"),
			options	=> $options,
			type	=> $type,
			user	=> $user,
		}
	}

	# installs a private key and its corresponding public key from the puppet master on the client
	define private_key( $user = "root", $type = "rsa", $storedir = "$ssh::storedir" ) {
		# ugly hack for home dir - how to do better?
		$home = $user ? {
			root	=> "",
			default	=> "/home",
		}
		file { "$home/$user/.ssh":
			ensure	=> directory,
			owner	=> $user,
			mode	=> 700,
		}
		file { "$home/$user/.ssh/id_$type.pub":
			ensure	=> file,
			content	=> generate("/bin/cat", "$storedir/id_$type.$name.pub"),
			owner	=> $user,
			mode	=> 644,
			require	=> File[ "$home/$user/.ssh" ],
		}
		file { "$home/$user/.ssh/id_$type":
			ensure	=> file,
			content	=> generate("/bin/cat", "$storedir/id_$type.$name"),
			owner	=> $user,
			mode	=> 600,
			require	=> File[ "$home/$user/.ssh" ],
		}
	}

}

class ssh::package {
	$pkg = $operatingsystem ? {
		centos	=> [ "openssh-clients", "openssh-server" ],
		default	=> "ssh",
	}
	package { $pkg:
		ensure => installed,
	}
}

class ssh::service {
	include ssh::package
	$svc = $operatingsystem ? {
		centos	=> "sshd",
		default	=> "ssh",
	}
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["ssh::package"],
	}
}

define ssh::without_password () {
	$file = "/etc/ssh/sshd_config"
	include ssh::service
	text::replace_lines { $file:
		file		=> $file,
		pattern		=> '^PermitRootLogin.*',
		replace		=> 'PermitRootLogin without-password',
		check		=> '^PermitRootLogin without-password',
		optimise	=> true,
		require		=> Class["ssh::package"],
		notify		=> Class["ssh::service"],
	}
}

