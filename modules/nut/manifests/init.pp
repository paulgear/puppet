# puppet classes to manage nut - choose only one of slave or master
#
# Example usage:
#
# 1. Standalone USB UPS
#	nut::ups::usbhid { "apcusb": }
#	nut::master::config { $fqdn:
#		ups		=> "apcusb",
#		username	=> "master",
#		password	=> "mymasterpassword",
#	}
#
# 2. Serial UPS with port specified
#	nut::ups::apcsmart_serial { "apcsmart": port => "/dev/ttyS1" }
#
# 3. Serial UPS and slaves allowed to connect
#	nut::ups::apcsmart_serial { "apcsmart": }
#	nut::master::config { $fqdn:
#		ups		=> "apcsmart",
#		username	=> "master",
#		password	=> "mymasterpassword",
#	}
#	nut::master::acl { "slave_acl":
#		match		=> "192.168.1.0/24",
#		action		=> "ACCEPT",
#	}
#	nut::master::user { "slaves": # <- ignored - use an arbitrary unique tag
#		username	=> "myslave",
#		password	=> "myslavepassword",
#		type		=> "slave",
#		allowfrom	=> "slave_acl",		# ACLs only supported on NUT 2.2 and earlier
#	}
#
# 4. Slave of the above system, with upssched used to shut down after 180 seconds of no power
#	nut::slave::config { $fqdn:
#		ups		=> "apcsmart",
#		master		=> "master's fqdn",
#		username	=> "myslave",
#		password	=> "myslavepassword",
#		upssched	=> "true",
#		gracesconds	=> 180,
#	}
#

class nut {
	case $::osfamily {
	Debian: {
		$dir		= "/etc/nut"
		$group		= "nut"
		$user		= "root"
		$master_pkgs	= [ "nut" ]
		$master_svc	= "nut"
		$slave_pkgs	= [ "nut" ]
		$slave_svc	= "nut"
	}
	RedHat: {
		$dir		= "/etc/ups"
		$group		= "nut"
		$user		= "nut"
		$master_pkgs	= [ "nut", "nut-client", ]
		$master_svc	= "ups"
		$slave_pkgs	= [ "nut-client" ]
		$slave_svc	= "nut"
	}
	default: {
		fail("The ${module_name} module is not supported on ${::osfamily}-based systems")
	}

	$users = "$dir/upsd.users"
	$frags = "$users.d"
}

class nut::master {
	include nut::master::package
	include nut::master::service
}

class nut::master::package {
	include nut
	package { $nut::master_pkgs:
		ensure	=> installed,
	}
}

class nut::master::service {
	include nut
	service { $nut::master_svc:
		enable	=> true,
		require	=> Class["nut::master::package"],
	}
}

define nut::report (
	$mailto = "root@localhost",
	$syslog = "/var/log/sysmgt/all"
) {
	file { "/usr/local/bin/nut-report":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/nut/nut-report.sh",
	}
	cron_job { "000-nut-report":
		interval	=> weekly,
		script		=> "#!/bin/sh
# Managed by puppet on $servername - do not edit here
/usr/local/bin/nut-report '$mailto' '$syslog'
",
	}
}

class nut::slave {
	include nut::slave::package
	include nut::slave::service
}

class nut::slave::package {
	include nut
	package { $nut::slave_pkgs:
		ensure	=> installed,
	}
}

class nut::slave::service {
	include nut
	service { $nut::slave_svc:
		enable		=> true,
		require		=> Class["nut::slave::package"],
	}
}

class nut::upssched {
	include nut
	file { "$nut::dir/upssched.conf":
		ensure	=> file,
		owner	=> $nut::user,
		group	=> $nut::group,
		mode	=> 640,
		content	=> template("nut/upssched.conf.erb"),
	}
	ulb { "upssched-cmd":
		source_class => "nut",
	}
}

class nut::user {
	include nut
	include concat::setup
	exec { "create $nut::users":
		command		=> "/usr/local/bin/concatfragments.sh -o $nut::users -d $nut::frags",
		onlyif		=> "test -n \"`find $nut::frags -newer $nut::users`\" -o ! -r $nut::users",
		logoutput	=> true,	# on_failure
		notify		=> Class["nut::master::service"],
	}
}

define nut::master::user (
		$username,
		$password,
		$type,
		$allowfrom = ""		# supported only on nut 2.2 and earlier
		) {
	include nut::master
	include nut::user
	concat::fragment { $name:
		content => template("nut/upsd.user.erb"),
	}
}

define nut::ups (
		$driver,
		$port,
		$desc = "",
		$sdtype = ""
		) {
	include nut
	include nut::master
	file { "$nut::dir/ups.conf":
		ensure	=> file,
		owner	=> $nut::user,
		group	=> $nut::group,
		mode	=> 644,
		content	=> template("nut/ups.conf.erb"),
		require	=> Class["nut::master::package"],
	}
}

define nut::ups::apcsmart_serial (
		$port = "/dev/ttyS0"
		) {
	nut::ups { $name:
		driver	=> "apcsmart",
		port	=> $port,
		sdtype	=> 0,
	}
}

define nut::ups::usbhid (
		$port = "auto"
		) {
	nut::ups { $name:
		driver	=> "usbhid-ups",
		port	=> $port,
	}
}

define nut::upsmon (
		$ups,
		$master,
		$username,
		$password,
		$mode,
		$numsupplies = 1,
		$graceseconds = 120,
		$upssched = ""
		) {
	include nut
	include nut::master
	file { "$nut::dir/upsmon.conf":
		ensure	=> file,
		owner	=> $nut::user,
		group	=> $nut::group,
		mode	=> 640,
		content	=> template("nut/upsmon.conf.erb"),
	}
	if ($upssched == "true") {
		include nut::upssched
	}
}

define nut::master::config (
		$ups,
		$username,
		$password,
		$master = "localhost",
		$numsupplies = 1,
		$graceseconds = 120,
		$upssched = ""
		) {
	include nut::master
	nut::upsmon { $name:
		ups		=> $ups,
		master		=> $master,
		numsupplies	=> $numsupplies,
		username	=> $username,
		password	=> $password,
		mode		=> master,
		graceseconds	=> 120,
		require		=> Class["nut::master::package"],
	}
	nut::master::user { $username:
		username	=> $username,
		password	=> $password,
		type		=> master,
		allowfrom	=> $master,
	}
}

define nut::slave::config (
		$ups,
		$master,
		$numsupplies = 1,
		$username,
		$password,
		$graceseconds = 120,
		$upssched = ""
		) {
	include nut::slave
	nut::upsmon { $name:
		ups		=> $ups,
		master		=> $master,
		numsupplies	=> $numsupplies,
		username	=> $username,
		password	=> $password,
		mode		=> slave,
		graceseconds	=> 120,
		require		=> Class["nut::slave::package"],
	}
}

