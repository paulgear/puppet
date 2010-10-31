# puppet class to install bridging utilities
# tested only on Debian

class bridge {

	package { "bridge-utils":
		ensure	=> installed,
	}

}
