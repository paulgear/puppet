# based on generic module from puppet.kumina.nl
#
# Copyright (c) 2009 by Kees Meijs <kees@kumina.nl> for Kumina bv.
# CC BY-SA 3.0 unported
# 
# Updates by Paul Gear <github@libertysys.com.au>
# Copyright (c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class aptitude {

	# location of commands
	$aptitude = "/usr/bin/aptitude"
	$apt_key = "/usr/bin/apt-key"
	$wget = "/usr/bin/wget"
	$apt_dir = "/etc/apt"
	$sources_dir = "$apt_dir/sources.list.d"
	$refresh = "$aptitude refresh"

	# set default package options
	Package {
		provider	=> "aptitude",
		require		=> Exec[$aptitude::refresh],
	}

	define source($sourcetype="deb", $uri, $distribution="stable", $components=[], $comment="", $ensure="file") {
		file { "$aptitude::sources_dir/$name.list":
			ensure	=> $ensure,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			content	=> template("aptitude/source.list"),
			require	=> File[$aptitude::sources_dir],
			notify	=> Exec[$aptitude::refresh],
		}
	}

	define key($ensure = 'present') {
		case $ensure {
			default: {
				err("unknown ensure value ${ensure}")
			}
			present: {
				exec { "$aptitude::wget -qq -O - 'http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x$name' | $aptitude::apt_key add -":
					unless	=> "$aptitude::apt_key export $name | grep -q -e '-----END PGP PUBLIC KEY BLOCK-----'",
					notify	=> Exec[$aptitude::refresh];
				}
			}
			absent: {
				exec { "$aptitude::apt_key del $name":
					onlyif	=> "$aptitude::apt_key list | grep -q -e $name",
				}
			}
		}
	}

	package { "wget":
		ensure	=> installed,
	}

	file { $sources_dir:
		ensure	=> directory,
	}

	# update aptitude when a config file changes
	exec { $refresh:
		command		=> "$aptitude update",
		refreshonly	=> true,
	}

}

# empty the sources.list file and save the original
define aptitude::sources_list () {

	$sources_file = "$aptitude::apt_dir/sources.list"
	$sources_file_save = "$sources_file.pre-puppet"

	file { $sources_file:
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		content		=> '# This file intentionally left blank - see /etc/apt/sources.list.d/*
',
		require		=> Exec[$sources_file_save],
		notify		=> Exec[$aptitude::refresh],
	}

	exec { $sources_file_save:
		command		=> "cp -af $sources_file $sources_file_save",
		creates		=> $sources_file_save,
		logoutput	=> true,
	}

}

