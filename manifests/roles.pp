######################################################################
# Example roles for puppet nodes
######################################################################

class role::fail2ban::winbind {
	include fail2ban::filters::winbind_remote_error
	include fail2ban::actions::winbind_restart
	include fail2ban::jails::winbind
}

class role::internetfacing {
        $pkgs = [ "rkhunter", "snort" ]
	package { $pkgs: ensure => installed }
}


class role::mailrelay {
	include amavis
	include clamav
	include mailgraph
	include spamassassin
}

class role::mailserver {
	include clamav
	include procmail
	include maillog
	include spamassassin
	include vacation
}

class role::ntpserver {
	include ntp::server
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

class role::puppet {
	include puppet::client
}

class role::puppetmaster {
	include puppet::server_conf
}

