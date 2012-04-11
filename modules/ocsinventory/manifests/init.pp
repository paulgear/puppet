#
# puppet class to install ocsinventory
#

class ocsinventory::package {
	$pkg = "ocsinventory-agent"
	package { $pkg:
		ensure => installed,
	}
}

define ocsinventory::client ( $server ) {
	include ocsinventory::package
	file { "/etc/ocsinventory/ocsinventory-agent.cfg":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 600,
		require	=> Class["ocsinventory::package"],
		content	=> "# Managed by puppet - do not edit here!\nserver=$server\n",
	}
}

class ocsinventory::server {
	include php5
	include ocsinventory::server::package
}


class ocsinventory::server::package {
	include mysql::client
	$pkg = "ocsinventory-server"
	package { $pkg:
		ensure	=> installed,
	}
}

class ocsinventory::server::delete_old {
	$file = "/etc/ocsinventory/delete_old.php"
	file { $file:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 600,
		require	=> Class["ocsinventory::server"],
		source	=> "puppet:///modules/ocsinventory/delete_old.php",
	}
	cron_job { "ocsinventory-delete-old":
		interval	=> daily,
		script		=> "#!/bin/sh
# created by puppet on $server - do not edit here
cd `dirname $file`
php -f $file
",
	}
}

