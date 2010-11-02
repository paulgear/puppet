#
# puppet class to install vacation
#
# DONE: Checked for Ubuntu compatibility
#

class vacation {
	package { "vacation":
		ensure	=> installed,
	}
}

