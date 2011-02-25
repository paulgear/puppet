# puppet class to manage observium

class observium {
	include observium::packages
}

class observium::packages {
	$deps = [

		"fping",
		"graphviz",
		"imagemagick",
		"ipcalc",
		"ipmitool",
		"libapache2-mod-php5",
		"mtr-tiny",
		"mysql-client",
		"nmap",
		"php5-cli",
		"php5-gd",
		"php5-mysql",
		"php5-snmp",
		"php5-xcache",
		"php-pear",
		"rrdtool",
		"sipcalc",
		"snmp",
		"snmp-mibs-downloader",
		"subversion",
		"whois",

	]
	package { $deps:
		ensure	=> installed,
	}
}

