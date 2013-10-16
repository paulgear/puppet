######################################################################
# Example roles for puppet nodes
######################################################################

class role::backuppc::server {
	include backuppc
}

class role::fail2ban::postfix {
	include role::fail2ban::shorewall_route
	include fail2ban::filters::postfix
	include fail2ban::jails::postfix
}

class role::fail2ban::ssh {
	include role::fail2ban::shorewall_route
	include fail2ban::jails::ssh
}

class role::fail2ban::shorewall_route {
	include shorewall
	include fail2ban::actions::route
	include fail2ban::actions::shorewall
}

class role::fail2ban::winbind {
	include fail2ban::filters::winbind_remote_error
	include fail2ban::actions::winbind_restart
	include fail2ban::jails::winbind
}

class role::internetfacing {
        $pkgs = [ "chkrootkit", "rkhunter" ]
	package { $pkgs: ensure => installed }
	ssh::without_password { $fqdn: }
}

class role::mailrelay {
	include amavis
	include amavis::decoders
	include clamav
	include mailgraph
	# maildrop is included here in case there are local users on the relay, e.g. for spamtraps
	include maildrop
	include postfix
	include postgrey
	include pyzor
	include razor
	include spamassassin
	include role::fail2ban::postfix
}

class role::mailserver {
	include role::mailrelay
	include dovecot
	include postfix::sasl
}

class role::mysql::server {
	include ::mysql::server
	include phpmyadmin
}

class role::ntpserver {
	include ntp::server
}

class role::puppet {
	include puppet::client
}

class role::puppetmaster {
	include puppet::server_conf
}

class role::squid_standard {
	include squid
	squid::squid_conf { "$fqdn squid": }
}

class role::vmware_guest {
	include vmware::tools
}

class role::vmware_host {
	include vmware::server
}

class role::vyatta_build {
	$pkgs = [

		"autoconf",
		"autogen",
		"automake",
		"autotools-dev",
		"bash-completion",
		"bison",
		"build-essential",
		"cdbs",
		"curl",
		"debhelper",
		"devscripts",
		"flex",
		"gawk",
		"gcc-multilib",
		"genisoimage",
		"git",
		"git-buildpackage",
		"hardening-wrapper",
		"kernel-package",
		"libapt-pkg-dev",
		"libatm1-dev",
		"libattr1-dev",
		"libboost-filesystem1.42-dev",
		"libcap-dev",
		"libcurl4-openssl-dev",
		"libdb-dev",
		"libdevmapper-dev",
		"libdumbnet-dev",
		"libedit-dev",
		"libexpat1-dev",
		"libfile-sync-perl",
		"libfreetype6-dev",
		"libgcrypt11-dev",
		"libglib2.0-dev",
		"libgmp3-dev",
		"libgnutls-dev",
		"libkrb5-dev",
		"libldap2-dev",
		"liblzo2-dev",
		"libmozjs-dev",
		"libmysqlclient-dev",
		"libncurses5-dev",
		"libnetfilter-conntrack-dev",
		"libnfnetlink-dev",
		"libopensc2-dev",
		"libpam0g-dev",
		"libpcap0.8-dev",
		"libpci-dev",
		"libpcre3-dev",
		"libperl-dev",
		"libpopt-dev",
		"libprelude-dev",
		"libreadline5-dev",
		"libsnmp-dev",
		"libsort-versions-perl",
		"libssl-dev",
		"libtool",
		"libusb-dev",
		"libxml2-dev",
		"lintian",
		"live-helper",
		"python-all-dev",
		"python-setuptools",
		"quilt",
		"ruby",
		"syslinux",
		"unifont",
		"unzip",

	]
	package { $pkgs:
		ensure => installed,
	}
}

class role::xen_guest {
	include network::interfaces
	package { "ethtool":
		ensure  => installed,
		notify  => File["/etc/network/interfaces"],
	}
}

