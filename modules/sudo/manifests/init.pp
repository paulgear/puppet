# puppet class to manage sudo

class sudo {
	include sudo::package
}

class sudo::package {
	$pkg = "sudo"
	package { $pkg:
		ensure => installed,
	}
}

define sudo::sudoers (
		$superusers = [ "root" ],
		$nopasswd = []
		) {
	include sudo
	$templatedir = "/etc/puppet/modules/sudo/templates"
	file { "/etc/sudoers":
		owner	=> "root",
		group	=> "root",
		mode	=> 440,
		content	=> template("sudo/sudoers.erb"),
		require	=> Class["sudo::package"],
	}
}

