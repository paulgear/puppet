# based on aptitude module from puppet.kumina.nl
#
# Copyright (c) 2009 by Kees Meijs <kees@kumina.nl> for Kumina bv.
# CC BY-SA 3.0 unported
#
# Updates by Paul Gear <github@libertysys.com.au>
# Copyright (c) 2010,2013 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class apt {

	# location of commands
	$apt_get = "/usr/bin/apt-get"
	$apt_key = "/usr/bin/apt-key"
	$wget = "/usr/bin/wget"
	$apt_dir = "/etc/apt"
	$sources_dir = "$apt_dir/sources.list.d"

	include apt::refresh

	# set default package options
	Package {
		provider	=> "apt",
		require		=> Class["apt::refresh"],
	}

	define source($sourcetype="deb", $uri, $distribution="stable", $components=[], $comment="", $ensure="file") {
		file { "$apt::sources_dir/$name.list":
			ensure	=> $ensure,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			content	=> template("apt/source.list"),
			require	=> File[$apt::sources_dir],
			notify	=> Class["apt::refresh"],
		}
	}

	define key(
		$ensure = 'present',
		$source = 'pgp',
	) {
		case $source {
			pgp: {
				$url = "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x$name"
			}
			default: {
				$url = $source
			}
		}
		case $ensure {
			default: {
				err("unknown ensure value ${ensure}")
			}
			present: {
				exec { "$apt::wget -qq -O - '$url' | $apt::apt_key add -":
					unless	=> "$apt::apt_key export $name | grep -q -e '-----END PGP PUBLIC KEY BLOCK-----'",
					notify	=> Class["apt::refresh"];
				}
			}
			absent: {
				exec { "$apt::apt_key del $name":
					onlyif	=> "$apt::apt_key list | grep -q -e $name",
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


}

class apt::refresh {
	# run apt-get update when a config file changes
	exec { "apt::refresh":
		command		=> "$apt::apt_get update",
		refreshonly	=> true,
	}
}

# empty the sources.list file and save the original
class apt::sources_list {
	include apt

	$sources_file = "$apt::apt_dir/sources.list"
	$sources_file_save = "$sources_file.pre-puppet"

	file { $sources_file:
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		content		=> '# This file intentionally left blank - see /etc/apt/sources.list.d/*
',
		require		=> Exec[$sources_file_save],
		notify		=> Class["apt::refresh"],
	}

	exec { $sources_file_save:
		command		=> "cp -af $sources_file $sources_file_save",
		creates		=> $sources_file_save,
		logoutput	=> true,
	}

}

