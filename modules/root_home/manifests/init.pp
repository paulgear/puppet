#
# puppet class to manage root's home directory files
#

class root_home {

	file { "/root/.bashrc":
		owner	=> root,
		group	=> root,
		mode	=> 644,
		ensure	=> file,
		source	=> "puppet:///modules/root_home/.bashrc",
	}

	file { "/root/.vimrc":
		owner	=> root,
		group	=> root,
		mode	=> 644,
		ensure	=> file,
		source	=> "puppet:///modules/root_home/.vimrc",
	}

	file { "/root/.byobu":
		owner	=> root,
		group	=> root,
		mode	=> 755,
		ensure	=> directory,
	}

	file { "/root/.byobu/backend":
		owner	=> root,
		group	=> root,
		mode	=> 644,
		ensure	=> file,
		require	=> File["/root/.byobu"],
		content	=> "# Managed by puppet on $servername - do not edit here!
BYOBU_BACKEND=screen
",
	}

}

