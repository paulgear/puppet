# install etckeeper and use git to manage the files in /etc/

class etckeeper {

	include git

	$pkg		= "etckeeper"
	$dir		= "/etc/$pkg"
	$cfgfile	= "$dir/$pkg.conf"
	$init		= "$pkg init"

	file { $dir:
		ensure	=> directory,
		owner	=> root,
		group	=> root,
		mode	=> 755,
	}

	file { $cfgfile:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		require	=> File[$dir],
		content	=> '# etckeeper configuration managed by puppet
VCS="git"
HIGHLEVEL_PACKAGE_MANAGER=apt
LOWLEVEL_PACKAGE_MANAGER=dpkg
',
	}

	package { $pkg:
		ensure	=> installed,
		require	=> [ File[$cfgfile], Package[$git::pkg] ],
		notify	=> Exec[$init],
	}

	exec { $init:
		command		=> $init,
		creates		=> "/etc/.git",
		logoutput	=> on_failure,
	}

	cron_job { "$pkg-git-gc":
		interval	=> weekly,
		enable		=> false,
	}

	cron_job { "$pkg-git-fsck-weekly":
		interval	=> weekly,
		script		=> "#!/bin/sh
# Managed by puppet on $servername - do not edit here!
cd /etc
git fsck --full --strict 2>&1 | grep -ve '^dangling blob'
",
	}

	cron_job { "$pkg-git-gc-daily":
		interval	=> daily,
		script		=> "#!/bin/sh
# Managed by puppet on $servername - do not edit here!
cd /etc
git gc --quiet
",
	}

}

