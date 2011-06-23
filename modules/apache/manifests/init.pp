# puppet class to install and enable apache

class apache {
	include apache::service
}

class apache::config {
	case $operatingsystem {
		centos: {
			$pkg = "httpd"
			$svc = "httpd"
		}
		default: {
			$pkg = "apache2"
			$svc = "apache2"
		}
	}
}

class apache::package {
	include apache::config
	package { "${apache::config::pkg}":
		ensure	=> installed,
	}
}

class apache::service {
	include apache::config
	include apache::package
	service { "${apache::config::svc}":
		enable	=> true,
		require	=> Class["apache::package"],
	}
}

