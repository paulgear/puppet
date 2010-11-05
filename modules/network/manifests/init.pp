#
# puppet class to create static bond/bridge network interfaces
#

class network::interfaces {

	include network::static

	file { "/etc/network/interfaces":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		source	=> "puppet:///modules/network/interfaces/$fqdn",
	}

}

