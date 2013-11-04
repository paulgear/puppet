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
		content	=> "# Managed by puppet on $servername - do not edit here\nserver=$server\n",
	}
	if $operatingsystem == "centos" {
		include text
		text::replace_lines { "$fqdn ocsinventory-agent":
			file	=> '/etc/sysconfig/ocsinventory-agent',
			pattern	=> '^OCSMODE\[0\]=none',
			replace	=> 'OCSMODE[0]=cron',
			optimise=> 1,
		}
	}
}

class ocsinventory::server {
	include php5
	include ocsinventory::server::package
}


class ocsinventory::server::package {
	include mysql::client
	$pkgs = [ "ocsinventory-server", "libsoap-lite-perl", ]
	package { $pkgs:
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
# Managed by puppet on $servername - do not edit here
cd `dirname $file`
php -f $file
",
	}
}

