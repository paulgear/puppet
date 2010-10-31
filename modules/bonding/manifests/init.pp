# puppet class to manage ethernet bonding
# tested only on Debian

class bonding {

	package { "ifenslave":
		ensure => installed
	}

}
