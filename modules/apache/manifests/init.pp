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

define apache::vhost () {
	include apache::config
	include apache::service
	file { "${apache::config::vhost}/$name":
		mode	=> 640,
		owner	=> "${apache::config::owner}",
		group	=> "${apache::config::group}",
	}
}

