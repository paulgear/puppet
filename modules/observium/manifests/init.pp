# puppet class to manage observium

class observium {
	include observium::packages
}

class observium::packages {
	include apache
	include php5
	include snmp

	$common_pkgs = [

		"fping",
		"graphviz",
		"nmap",
		"php-pear",
		"rrdtool",
		"subversion",

	]
	$deb_pkgs = [

		"imagemagick",
		"ipcalc",
		"ipmitool",
		"libapache2-mod-php5",
		"mtr-tiny",
		"mysql-client",
		"php5-cli",
		"php5-gd",
		"php5-mysql",
		"php5-snmp",
		"php5-xcache",
		"sipcalc",
		"snmp",
		"snmp-mibs-downloader",
		"whois",

	]
	$centos_pkgs = [

		"ImageMagick",
		"jwhois",
		"mysql",
		"net-snmp-utils",
		"OpenIPMI-tools",
		"php-gd",
		"php-mysql",
		"php-pecl-apc",
		"php-snmp",

	]

	$ospkgs = $operatingsystem ? {
		Debian	=> $deb_pkgs,
		Ubuntu	=> $deb_pkgs,
		CentOS	=> $centos_pkgs,
	}
	package { $common_pkgs:
		ensure	=> installed,
	}
	package { $ospkgs:
		ensure	=> installed,
	}
}

