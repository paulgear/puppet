# puppet classes to manage nut - choose only one of slave or master
#
# Example usage:
#
# 1. Standalone USB UPS
#	nut::ups::apc_smart_750 { "apcusb": }
#	nut::master::config { $fqdn:
#		ups		=> "apcusb",
#		username	=> "master",
#		password	=> "mymasterpassword",
#	}
#
# 2. Serial UPS with port specified
#	nut::ups::apc_smart_1400xl { "apcsmart": port => "/dev/ttyS1" }
#
# 3. Serial UPS and slaves allowed to connect
#	nut::ups::apc_smart_3000xl { "apcsmart": }
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
#		allowfrom	=> "slave_acl",
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
	$dir = $operatingsystem ? {
		centos	=> "/etc/ups",
		debian	=> "/etc/nut",
		ubuntu	=> "/etc/nut",
	}
	$group = $operatingsystem ? {
		centos	=> "nut",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	$user = $operatingsystem ? {
		centos	=> "nut",
		debian	=> "root",
		ubuntu	=> "root",
	}
	$users = "$dir/upsd.users"
	$frags = "$users.d"
}

class nut::master {
	include nut::master::package
	include nut::master::service
}

class nut::master::package {
	$pkg = $operatingsystem ? {
		centos	=> [ "nut", "nut-client", ],
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class nut::master::service {
	$svc = $operatingsystem ? {
		centos	=> "ups",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
}

class nut::report {
	$mailto = "root@localhost"
	file { "/usr/local/bin/nut-report":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/nut/nut-report.sh",
	}
	cron_job { "000-nut-report":
		interval	=> weekly,
		# Beware!  Here be quoting dragons.
		script		=> "#!/bin/sh
# Managed by puppet on $servername - do not edit here
set -e
set -u
if [ `date +%w` = 0 ]; then
	TMPFILE=`mktemp`
	/usr/local/bin/nut-report >\$TMPFILE 2>&1
	test -s \$TMPFILE && mail -s 'Weekly UPS report' $mailto < \$TMPFILE
fi
",
	}
}

class nut::slave {
	include nut::slave::package
	include nut::slave::service
}

class nut::slave::package {
	$pkg = $operatingsystem ? {
		centos	=> "nut-client",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

class nut::slave::service {
	$svc = $operatingsystem ? {
		centos	=> "ups",
		debian	=> "nut",
		ubuntu	=> "nut",
	}
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
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
		$allowfrom,
		$type
		) {
	include nut::user
	concat::fragment { $name:
		content => template("nut/upsd.user.erb"),
	}
}

define nut::config::ups (
		$desc,
		$driver,
		$port,
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
		require	=> Class["nut::master::package",
	}
}

define nut::ups::apc_back_cs500 (
		$port = "auto"
		) {
	nut::config::ups { $name:
		desc	=> "APC BackUPS CS500",
		driver	=> "usbhid-ups",
		port	=> $port,
	}
}

define nut::ups::apc_smart_750 (
		$port = "auto"
		) {
	nut::config::ups { $name:
		desc	=> "APC SmartUPS 750",
		driver	=> "usbhid-ups",
		port	=> $port,
	}
}

define nut::ups::apc_smart_1400xl (
		$port = "/dev/ttyS0"
		) {
	nut::config::ups { $name:
		desc	=> "APC SmartUPS 1400XL",
		driver	=> "apcsmart",
		port	=> $port,
		sdtype	=> 0,
	}
}

define nut::ups::apc_smart_3000xl (
		$port = "/dev/ttyS0"
		) {
	nut::config::ups { $name:
		desc	=> "APC SmartUPS 3000XL",
		driver	=> "apcsmart",
		port	=> $port,
		sdtype	=> 0,
	}
}

define nut::config::upsmon (
		$ups,
		$master,
		$numsupplies = 1,
		$username,
		$password,
		$mode,
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
		$master = "localhost",
		$numsupplies = 1,
		$username,
		$password,
		$graceseconds = 120,
		$upssched = ""
		) {
	include nut::master
	nut::config::upsmon { $name:
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
	nut::config::upsmon { $name:
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

