#
# puppet class to create network interfaces file
#

class network::interfaces {

	include network::static

	file { "/etc/network/interfaces":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> generate("/bin/cat", "/etc/puppet/modules/network/files/interfaces/$fqdn"),
	}

}

