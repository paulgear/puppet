# puppet class to install openvpn

class openvpn {
	include	openvpn::package
	include openvpn::service
}

class openvpn::package {
	$pkg = "openvpn"
	package { $pkg:
		ensure	=> installed,
	}
}

class openvpn::service {
	include openvpn::package
	$svc = "openvpn"
	service { $svc:
		enable	=> true,
		require	=> Class["openvpn::package"],
	}
}

class openvpn::config {
	include openvpn
	$dir = "/etc/openvpn"
	file { $dir:
		ensure	=> directory,
		recurse	=> true,
		owner	=> root,
		group	=> root,
		source	=> "puppet:///modules/openvpn/$fqdn",
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
	}
}

class openvpn::pingtest {
	include openvpn::service
	$file = "/usr/local/bin/pingtest"
	file { $file:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		source	=> "puppet:///modules/openvpn/pingtest",
		require	=> Class["openvpn::service"],
	}
	cron_job { "openvpn-pingtest":
		interval	=> "d",
		script		=> "# Managed by puppet on $server - do not edit here
*/10 * * * * root $file
",
	}
}

define openvpn::client ( $cfgname = "client", $remotes, $remote_random = "false" ) {
	include openvpn
	$cfg = "$cfgname.conf"
	$dir = "/etc/openvpn"
	file { "$dir/$cfg":
		mode	=> 644,
		owner	=> root,
		group	=> root,
		require	=> Class["openvpn::package"],
		notify	=> Class["openvpn::service"],
		content	=> template("openvpn/$cfg.erb"),
	}
}

