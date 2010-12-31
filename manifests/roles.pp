######################################################################
# Example roles for puppet nodes
######################################################################

class role::fail2ban::postfix {
	include shorewall
	include fail2ban::actions::route
	include fail2ban::actions::shorewall
	include fail2ban::filters::postfix
	include fail2ban::jails::postfix
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
	include clamav
	include mailgraph
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
	include maildrop
	include postfix::sasl
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

class role::xen_guest {
	include network::interfaces
	package { "ethtool":
		ensure  => installed,
		notify  => File["/etc/network/interfaces"],
	}
}

