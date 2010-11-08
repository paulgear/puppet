# install etckeeper and use git to manage the files in /etc/

class etckeeper {

	$pkg		= "etckeeper"
	$cfgfile	= "/etc/$pkg/$pkg.conf"
	$init		= "etckeeper init"

	file { $cfgfile:
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> '# etckeeper configuration managed by puppet
VCS="git"
HIGHLEVEL_PACKAGE_MANAGER=apt
LOWLEVEL_PACKAGE_MANAGER=dpkg
',
	}

	package { $pkg:
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

