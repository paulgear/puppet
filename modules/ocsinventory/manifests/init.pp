#
# puppet class to install ocsinventory
#

class ocsinventory {

	$pkg = "ocsinventory-agent"

	package { $pkg:
		ensure => installed,
	}

	define client ( $server ) {
		file { "/etc/ocsinventory/ocsinventory-agent.cfg":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 600,
			require	=> Package[$ocsinventory::pkg],
			content	=> "# Managed by puppet - do not edit here!\nserver=$server\n",
		}
	}

}

