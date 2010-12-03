#
# puppet class to manage Dan's Guardian
#
# DONE: Checked for Ubuntu compatibility
#

class dansguardian {
	# configuration variables
	$basedir = "/etc/dansguardian"
	$listdir = "$basedir/lists"
	$puppetdir = "/etc/puppet/modules/dansguardian"
	$pkg = "dansguardian"
	$svc = "dansguardian"
	$notify = "dansguardian reload"
	$user = $operatingsystem ? {
		centos	=> "nobody",
		default	=> "dansguardian",
	}
	$group = $operatingsystem ? {
		centos	=> "nobody",
		default	=> "dansguardian",
	}
	$langdir = $operatingsystem ? {
		centos	=> "/usr/share/dansguardian/languages",
		default	=> "$basedir/languages",
	}

	include utils
	include dansguardian::package
	include dansguardian::files
	include dansguardian::directories
	include dansguardian::cron
	include dansguardian::groups

	# define the local configuration
	define config ( $type = 'normal', $allowbypass = 1 ) {

		# make DG user a member of the clamav group to enable virus scanning
		user { "$dansguardian::user":
			groups	=>	"clamav",
		}

		$numfiltergroups = 5
		$filtergroups_description = "
# filter1 = default keyword weighted phrase limit, blanket IP block active, bypass NOT allowed
# filter2 = unfiltered system users and computers (not terminal servers)
# filter3 = blanket IP block INACTIVE (allows Skype, gotomeeting, etc.), default filtering, bypass allowed
# filter4 = higher weighted phrase limit, blanket IP block active, bypass allowed
# filter5 = blanket block active, allowed sites only, bypass NOT allowed
"

		dansguardian::groups::filter_conf { "f1":
			filtergroup		=> 1,
			extra_categories	=> $type ? {
				default			=> [ "blanket-ip" ],
			},
			allowbypass		=> $type ? {
				default			=> 0,
			},
		}

		dansguardian::groups::filter_conf { "f2":
			filtergroup		=> 2,
			groupmode		=> 2,
			default_blacklists	=> [],
			default_categories	=> [],
			allowbypass		=> $allowbypass,
		}

		dansguardian::groups::filter_conf { "f3":
			filtergroup		=> 3,
			allowbypass		=> $allowbypass,
		}

		dansguardian::groups::filter_conf { "f4":
			filtergroup		=> 4,
			naughtynesslimit	=> 200,
			extra_categories	=> [ "blanket-ip", ],
			allowbypass		=> $allowbypass,
		}

		dansguardian::groups::filter_conf { "f5":
			filtergroup		=> 5,
			extra_categories	=> [ "blanket-block", "blanket-ip", ],
			allowbypass		=> 0,
		}

		# master config file
		file { "$dansguardian::basedir/dansguardian.conf":
			ensure	=> file,
			owner	=> root,
			group	=> $dansguardian::group,
			mode	=> 640,
			require	=> Package[$dansguardian::pkg],
			notify	=> Exec[$dansguardian::notify],
			content	=> template("dansguardian/dansguardian.conf.erb"),
		}

		# filter group definitions
		$puppetdir = $dansguardian::puppetdir
		file { "$dansguardian::listdir/filtergroupslist":
			ensure	=> file,
			owner	=> root,
			group	=> $dansguardian::group,
			mode	=> 640,
			require	=> Package[$dansguardian::pkg],
			notify	=> Exec[$dansguardian::notify],
			content	=> template("dansguardian/filtergroupslist.erb"),
		}

	}

}

class dansguardian::cron {

	# update the blacklists nightly
	cron_job { "dansguardian-update":
		interval	=> "d",
		script		=> "# created by puppet
0 2 * * * root /usr/local/bin/randomsleep 3600; rsync -rtz squidguard.mesd.k12.or.us::filtering /etc/dansguardian/lists/blacklists/ && /usr/sbin/dansguardian -r
",
	}

}

class dansguardian::directories {

	# manage the entire dansguardian lists directory
	file { "$dansguardian::listdir":
		ensure		=> directory,
		owner		=> root,
		group		=> $dansguardian::group,
		mode		=> 750,
		require		=> Package[$dansguardian::pkg],
		notify		=> Exec[$dansguardian::notify],
		recurse		=> true,
		ignore		=> [ ".*.swp" ],
		source		=> "puppet:///modules/dansguardian/lists",
	}

	# manage permissions on the dansguardian blacklists directory
	file { "$dansguardian::listdir/blacklists":
		ensure		=> directory,
		owner		=> $dansguardian::user,
		group		=> $dansguardian::group,
		mode		=> 750,
		recurse		=> true,
		require		=> Package[$dansguardian::pkg],
		notify		=> Exec[$dansguardian::notify],
	}

}

class dansguardian::files {

	# the template file for the page which is displayed when a site is blocked
	file { "${dansguardian::langdir}/ukenglish/bypasstemplate.html":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require	=> Package[$dansguardian::pkg],
		notify	=> Exec[$dansguardian::notify],
		source	=> "puppet:///modules/dansguardian/bypasstemplate.html",
	}

	file { "${dansguardian::langdir}/ukenglish/nobypasstemplate.html":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require	=> Package[$dansguardian::pkg],
		notify	=> Exec[$dansguardian::notify],
		source	=> "puppet:///modules/dansguardian/nobypasstemplate.html",
	}

	file { "$dansguardian::basedir/contentscanners/clamdscan.conf":
		ensure	=> file,
		owner	=> root,
		group	=> $dansguardian::group,
		mode	=> 640,
		require	=> Package[$dansguardian::pkg],
		notify	=> Exec[$dansguardian::notify],
		source	=> "puppet:///modules/dansguardian/clamdscan.conf",
	}

	file { "/etc/logrotate.d/dansguardian":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require	=> Package[$dansguardian::pkg],
		source	=> "puppet:///modules/dansguardian/dansguardian.logrotate",
	}

}

class dansguardian::package {

	# ensure package is installed
	package { "$dansguardian::pkg":
		ensure	=> installed,
	}

	# ensure service starts on boot
	service { "$dansguardian::svc":
		enable		=> true,
		hasrestart	=> true,
		require		=> Package[$dansguardian::pkg],
	}

	# run a soft refresh (for use during business hours)
	exec { "$dansguardian::notify":
		command		=> "/usr/sbin/dansguardian -g",
		logoutput	=> true,
		refreshonly	=> true,
	}

	# run a full restart (for use outside business hours)
#	exec { "dansguardian restart":
#		command		=> "/usr/sbin/dansguardian -r",
#		logoutput	=> true,
#		refreshonly	=> true,
#	}

}

class dansguardian::groups {

	# definition for filtergroup bannedlist/exceptionlist files
	define list_file ($basename, $filtergroup, $default_blacklists, $default_categories,
			$extra_blacklists, $extra_categories, $blacklist_type,
			$puppetdir = $dansguardian::puppetdir) {
		file { "$dansguardian::listdir/$name":
			ensure	=> file,
			owner	=> root,
			group	=> $dansguardian::group,
			mode	=> 640,
			require	=> Package[$dansguardian::pkg],
			notify	=> Exec[$dansguardian::notify],
			content	=> template("dansguardian/list-master.erb"),
		}
	}

	# definition for filtergroup configuration files
	define filter_conf ($filtergroup, $groupmode = 1, $naughtynesslimit = 150,
			$allowbypass = 0,
			$default_blacklists = [ "hacking", "porn", "proxy", "warez", ],
			$default_categories = [ "ISP-$isp",
				"bandwidth-wasters", "chat", "malware",
				"parked-domains", "porn", "proxy-bypass", "vendor-ip", ],
			$extra_blacklists = [],
			$extra_categories = []) {
		# create this filtergroup's config file
		file { "$dansguardian::basedir/dansguardianf$filtergroup.conf":
			ensure	=> file,
			owner	=> root,
			group	=> $dansguardian::group,
			mode	=> 640,
			require	=> Package[$dansguardian::pkg],
			notify	=> Exec[$dansguardian::notify],
			content	=> template("dansguardian/dansguardianf1.conf.erb"),
		}

		# create ban & exception lists for this group
		dansguardian::groups::list_file { "bannedsitelistf$filtergroup":
			basename		=> "bannedsitelist",
			filtergroup		=> $filtergroup,
			default_categories	=> $default_categories,
			default_blacklists	=> $default_blacklists,
			extra_categories	=> $extra_categories,
			extra_blacklists	=> $extra_blacklists,
			blacklist_type		=> "domains",
		}

		dansguardian::groups::list_file { "exceptionsitelistf$filtergroup":
			basename		=> "exceptionsitelist",
			filtergroup		=> $filtergroup,
			default_categories	=> $default_categories,
			default_blacklists	=> [],
			extra_categories	=> $extra_categories,
			extra_blacklists	=> [],
			blacklist_type		=> "",
		}

		dansguardian::groups::list_file { "bannedurllistf$filtergroup":
			basename		=> "bannedurllist",
			filtergroup		=> $filtergroup,
			default_categories	=> $default_categories,
			default_blacklists	=> $default_blacklists,
			extra_categories	=> $extra_categories,
			extra_blacklists	=> $extra_blacklists,
			blacklist_type		=> "urls",
		}

		dansguardian::groups::list_file { "exceptionurllistf$filtergroup":
			basename		=> "exceptionurllist",
			filtergroup		=> $filtergroup,
			default_categories	=> $default_categories,
			default_blacklists	=> [],
			extra_categories	=> $extra_categories,
			extra_blacklists	=> [],
			blacklist_type		=> "",
		}

	}

}

