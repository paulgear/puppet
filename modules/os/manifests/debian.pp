# debian-specific configuration

class os::debian {

	include apt
	include hostname::setfqdn
	include isp

	# assume all services have a restart and a status, even if it's not true
	Service {
		hasrestart	=> true,
		hasstatus	=> true,
	}

	# extras for bare metal hosts
	case $virtual {
		physical, vmware_server, vserver_host, xen0: {
			include os::debian::physical
		}
	}

	define base($components = ["main", "contrib", "non-free"], $ensure = "file") {
		apt::source { "$name-main":
			ensure		=> $ensure,
			comment		=> "$operatingsystem base distribution",
			uri		=> "$isp::debianbase",
			distribution	=> "$name",
			components	=> $components,
		}
	}

	define security($components = ["main", "contrib", "non-free"], $ensure = "file") {
		apt::source { "$name-security":
			ensure		=> $ensure,
			comment		=> "$operatingsystem security updates",
			uri		=> "http://security.debian.org/",
			distribution	=> "$name/updates",
			components	=> $components,
		}
	}

	define updates($components = ["main", "contrib", "non-free"], $ensure = "file") {
		apt::source { "$name-updates":
			ensure		=> $ensure,
			comment		=> "$operatingsystem $lsbdistcodename updates",
			uri		=> "$isp::debianbase",
			distribution	=> "$name-updates",
			components	=> $components,
		}
	}

	define volatile($components = ["main", "contrib", "non-free"], $ensure = "file") {
		apt::source { "$name-volatile":
			ensure		=> $ensure,
			comment		=> "$operatingsystem volatile updates",
			uri		=> "http://volatile.debian.org/debian-volatile",
			distribution	=> "$name/volatile",
			components	=> $components,
		}
	}

	define backports($components = ["main", "contrib", "non-free"], $ensure = "file") {
		apt::source { "$name-backports":
			ensure		=> $ensure,
			comment		=> "$operatingsystem backports from testing/unstable",
			uri		=> "$isp::debianbackports",
			distribution	=> "$name-backports",
			components	=> $components,
		}
		apt::key { "EA8E8B2116BA136C":
			ensure		=> $ensure ? {
				absent	=> "absent",
				default	=> "present",
			},
		}
	}

	case $lsbdistcodename {

		"n/a": {
			include "os::debian::squeeze"
		}

		default: {
			include "os::debian::$lsbdistcodename"
		}

	}

}

class os::debian::packages {

	# packages to install
	# this is one package per line to make it easier for local modifications
	$packages = [

		'acct',
		'apt-show-versions',
		'at',
		'bc',
		'bsd-mailx',
		'byobu',
		'bzip2',
		'deborphan',
		'debsums',
		'file',
		'ftp',
		'iftop',
		'iotop',
		'iptraf',
		'less',
		'lsb-release',
		'lsof',
		'lsscsi',
		'ltrace',
		'mlocate',
		'needrestart',
		'netcat-traditional',
		'openssl',
		'patch',
		'perl',
		'psmisc',
		'screen',
		'strace',
		'telnet',
		'time',
		'tshark',
		'vim',

	]
	package { $packages:
		ensure	=> installed,
	}

	# packages to remove
	$removepackages = [
		"nvi",
		"vim-tiny",
	]
	package { $removepackages:
		ensure	=> purged,
	}

	include etckeeper
	include make
	include sysstat

}

class os::debian::desktop {
	$packages = [ "gdm", "gnome-core", "xserver-xorg" ]
	package { $packages: ensure => installed }
}

class os::debian::physical {
	$packages = "pciutils"
	package { $packages: ensure => installed }
}

class os::debian::jessie {
	os::debian::base	{ "jessie": }
	os::debian::security	{ "jessie": }
	os::debian::updates	{ "jessie": }
}

class os::debian::wheezy {
	os::debian::base	{ "wheezy": }
	os::debian::security	{ "wheezy": }
	os::debian::updates	{ "wheezy": }
	os::debian::backports	{ "wheezy": }
}

class os::debian::sid {
	os::debian::base	{ "unstable": }
	os::debian::security	{ "unstable": ensure => absent }
	os::debian::volatile	{ "unstable": ensure => absent }
	os::debian::backports	{ "unstable": ensure => absent }
}

