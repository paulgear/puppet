# Description:	puppet module to manage fail2ban
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban {

	require concat::setup

	$pkg = "fail2ban"
	$svc = "fail2ban"
	$dir = "/etc/fail2ban"
	$jail_local = "$dir/jail.local"
	$jail_d = "$dir/jail.d"
	$action_d = "$dir/action.d"
	$filter_d = "$dir/filter.d"
	$dirs = [ "$dir", "$action_d", "$filter_d", "$jail_d", "$jail_d/fragments" ]
	$exec = "create-fail2ban-jails"
	$default_ignoreip = "127.0.0.1\n\t10.0.0.0/8\n\t192.168.0.0/16\n\t172.16.0.0/12"

	# install package
	package { $pkg: ensure => installed }

	# enable service
	service { $svc:
		enable		=> true,
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> Package[$pkg],
	}

	# create configuration directories
	file { $dirs:
		ensure		=> directory,
		mode		=> 750,
		require		=> Package[$pkg],
	}

	# exec to create jail.local from jail.d
	exec { $exec:
		command		=> "/usr/local/bin/concatfragments.sh -o $jail_local -d $jail_d",
		refreshonly	=> true,
	}

}

# NOTE: action $name must not contain spaces - see fail2ban::actions::* for examples
define fail2ban::action ( $actionstart = "", $actionstop = "", $actioncheck = "",
		$actionban = "", $actionunban = "" ) {
	include fail2ban
	file { "${fail2ban::action_d}/$name.local":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 640,
		notify	=> Service["$fail2ban::svc"],
		content	=> "# fail2ban action managed by puppet
[Definition]
actionstart	= $actionstart
actionstop	= $actionstop
actioncheck	= $actioncheck
actionban	= $actionban
actionunban	= $actionunban
",
	}
}

# NOTE: filter $name must not contain spaces - see fail2ban::filters::* for examples
define fail2ban::filter ( $failregex, $ignoreregex = "" ) {
	include fail2ban
	file { "$fail2ban::dir/filter.d/$name.local":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 640,
		notify	=> Service["$fail2ban::svc"],
		content	=> "# fail2ban filter managed by puppet
[Definition]
failregex	= $failregex
ignoreregex	= $ignoreregex
",
	}
}

# NOTE: jail $name must not contain spaces - see fail2ban::jails::* for examples
define fail2ban::jail (	
		$action = "",
		$bantime = "",
		$enabled = "true",
		$filter = "$name",
		$findtime = "",
		$ignoreip = "",
		$logpath = "",
		$maxretry = "",
		$port = "http,https"
		) {
	include fail2ban
	$banaction = ""
	$jailname = $name
	file { "${fail2ban::jail_d}/fragments/$name.local":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 640,
		content	=> template("fail2ban/jaildef.erb"),
		# if fail2ban ever supports jail.d, change this to
		#	notify	=> Service["$fail2ban::svc"],
		# as per the filters & actions above.
		notify	=> Exec["$fail2ban::exec"],
	}
}

define fail2ban::setup (
		$banaction = "",
		$bantime = "",
		$enabled = "",
		$filter = "",
		$findtime = "",
		$ignoreip = "${fail2ban::default_ignoreip}",
		$logpath = "",
		$maxretry = "",
		$port = ""
		) {
	include fail2ban
	$action = ""
	$jailname = "DEFAULT"
	file { "DEFAULT":
		path	=> "${fail2ban::jail_d}/fragments/000-DEFAULT",
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 640,
		content	=> template("fail2ban/jaildef.erb"),
		# if fail2ban ever supports jail.d, change this to
		#	notify	=> Service["$fail2ban::svc"],
		# as per the filters & actions above.
		notify	=> Exec["$fail2ban::exec"],
	}
}
