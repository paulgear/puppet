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
		"ipmitool"
		"libapache2-mod-php5",
		"mtr-tiny",
		"mysql-client",
		"nmap",
		"php5-cli",
		"php5-gd",
		"php5-mysql",
		"php5-snmp",
		"php-pear",
		"rrdtool",
		"sipcalc",
		"snmp",
		"subversion",
		"whois",
	]
	package { $deps:
		ensure	=> installed,
	}
}

