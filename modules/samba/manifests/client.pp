# puppet class to install samba client

class samba::client {
	include samba::client::package
}

class samba::client::package {
	$pkg = $operatingsystem ? {
		centos	=> $operatingsystemrelease ? {
			/^5/	=> "samba3-cifsmount",
			default	=> "cifs-utils",
		},
		debian	=> "smbfs",
		ubuntu	=> "smbfs",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

