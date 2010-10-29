#
# puppet class to install and enable apache
#
# DONE: Checked for Ubuntu compatibility
#

class apache {

	# set package names appropriately
	case $operatingsystem {
		centos: {
			$apache_pkg = "httpd"
			$apache_svc = "httpd"
		}
		default: {
			$apache_pkg = "apache2"
			$apache_svc = "apache2"
		}
	}

	package { $apache_pkg:
		ensure	=> installed,
	}

	service { $apache_svc:
		enable	=> true,
	}

}

