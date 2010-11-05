# puppet class to install default sudo configuration
# developed based on the examples in James Turnbull's "Pulling Strings with Puppet" book

class sudo {

	$pkg = "sudo"

	package { $pkg:
		ensure => installed,
	}

	file { "/etc/sudoers":
		owner	=> "root",
		group	=> "root",
		mode	=> 440,
		source	=> "puppet:///modules/sudo/sudoers",
		require	=> Package[$pkg],
	}

}
