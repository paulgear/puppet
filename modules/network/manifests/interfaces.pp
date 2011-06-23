#
# puppet class to manage network interfaces file
#

class network::interfaces {

	file { "/etc/network/interfaces":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> generate("/bin/cat", "/etc/puppet/modules/network/files/interfaces/$fqdn"),
	}

}

