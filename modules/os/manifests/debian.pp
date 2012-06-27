# debian-specific configuration

class os::debian {

	include aptitude
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
		aptitude::source { "$name-main":
			ensure		=> $ensure,
			comment		=> "$operatingsystem base distribution",
			uri		=> "$isp::debianbase",
			distribution	=> "$name",
			components	=> $components,
		}
	}

	define security($components = ["main", "contrib", "non-free"], $ensure = "file") {
		aptitude::source { "$name-security":
			ensure		=> $ensure,
			comment		=> "$operatingsystem security updates",
			uri		=> "http://security.debian.org/",
			distribution	=> "$name/updates",
			components	=> $components,
		}
	}

	define updates($components = ["main", "contrib", "non-free"], $ensure = "file") {
		aptitude::source { "$name-updates":
			ensure		=> $ensure,
			comment		=> "$operatingsystem $lsbdistcodename updates",
			uri		=> "$isp::debianbase",
			distribution	=> "$name-updates",
			components	=> $components,
		}
	}

	define volatile($components = ["main", "contrib", "non-free"], $ensure = "file") {
		aptitude::source { "$name-volatile":
			ensure		=> $ensure,
			comment		=> "$operatingsystem volatile updates",
			uri		=> "http://volatile.debian.org/debian-volatile",
			distribution	=> "$name/volatile",
			components	=> $components,
		}
	}

	define backports($components = ["main", "contrib", "non-free"], $ensure = "file") {
		aptitude::source { "$name-backports":
			ensure		=> $ensure,
			comment		=> "$operatingsystem backports from testing/unstable",
			uri		=> "$isp::debianbackports",
			distribution	=> "$name-backports",
			components	=> $components,
		}
		aptitude::key { "EA8E8B2116BA136C":
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

		"acct",
		"apt-show-versions",
		"at",
		"bc",
		"bsd-mailx",
		"bzip2",
		"deborphan",
		"debsums",
		"file",
		"ftp",
		"iftop",
		"iptraf",
		"less",
		"lsb-release",
		"lsof",
		"lsscsi",
		"ltrace",
		"mlocate",
		"openssl",
		"patch",
		"perl",
		"psmisc",
		"rsync",
		"screen",
		"strace",
		"telnet",
		"time",
		"tshark",
		"vim",
		"wireshark",

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

class os::debian::lenny {
	$components = ["main", "contrib", "non-free"]
	aptitude::source { "lenny-main":
		ensure		=> file,
		comment		=> "$operatingsystem base distribution",
		uri		=> "http://archive.debian.org/debian",
		distribution	=> "lenny",
		components	=> $components,
	}
	aptitude::source { "lenny-security":
		ensure		=> file,
		comment		=> "$operatingsystem security",
		uri		=> "http://archive.debian.org/debian-security",
		distribution	=> "lenny/updates",
		components	=> $components,
	}
	aptitude::source { "lenny-volatile":
		ensure		=> file,
		comment		=> "$operatingsystem volatile",
		uri		=> "http://archive.debian.org/debian-volatile",
		distribution	=> "lenny/volatile",
		components	=> $components,
	}
	aptitude::source { "lenny-backports":
		ensure		=> file,
		comment		=> "$operatingsystem backports",
		uri		=> "http://archive.debian.org/debian-backports",
		distribution	=> "lenny-backports",
		components	=> $components,
	}

	$packages = [ "sysvconfig" ]
	package { $packages: ensure => installed }

	case $architecture {
		armv5tel: {
			include tbm
		}
	}
}

class os::debian::squeeze {
	os::debian::base	{ "squeeze": }
	os::debian::security	{ "squeeze": }
	os::debian::updates	{ "squeeze": }
	os::debian::volatile	{ "squeeze": ensure => absent }
	#os::debian::backports	{ "squeeze": ensure => absent }

	$packages = [ "byobu" ]
	package { $packages: ensure => installed }
}

class os::debian::sid {
	os::debian::base	{ "unstable": }
	os::debian::security	{ "unstable": ensure => absent }
	os::debian::volatile	{ "unstable": ensure => absent }
	os::debian::backports	{ "unstable": ensure => absent }
}

