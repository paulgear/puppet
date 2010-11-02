#
# puppet class to manage root's home directory
#
# FIXME - Ubuntu: check files for Ubuntu-compatible behaviour
#

class root_home {

	file { "/root/.bashrc":
		source	=> "puppet:///modules/root_home/.bashrc",
		owner	=> root,
		group	=> root,
		mode	=> 644,
		ensure	=> file,
	}

	file { "/root/.vimrc":
		source	=> "puppet:///modules/root_home/.vimrc",
		owner	=> root,
		group	=> root,
		mode	=> 644,
		ensure	=> file,
	}

}

