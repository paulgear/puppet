# install etckeeper and use git to manage the files in /etc/

class etckeeper {

	$pkg		= "etckeeper"
	$pkgs		= [ $pkg, "git-core", ]
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

	package { $pkgs:
		ensure	=> installed,
		require	=> File[$cfgfile],
		notify	=> Exec[$init],
	}

	exec { $init:
		command		=> $init,
		creates		=> "/etc/.git",
		logoutput	=> on_failure,
	}

}

