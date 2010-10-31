#
# puppet class to ensure static network interfaces are used
#

# ensure fixed IP addresses used
class network::static {

	package { [ "network-manager", "network-manager-gnome" ]:
		ensure	=> purged,
	}

}

