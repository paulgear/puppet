#
# puppet class to manage procmail
#
# FIXME - Ubuntu: obsolete?
#

class procmail {

	$pkg = "procmail"
	$dir = $operatingsystem ? {
		default		=> "/etc/procmail",
	}

	package { $pkg:
		ensure		=> installed,
	}

	file { $dir:
		ensure		=> directory,
		owner		=> root,
		group		=> root,
		mode		=> 755,
		require		=> Package[$pkg],
	}

	file { "$dir/poisoned":
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		require		=> [ Package[$pkg], File[$dir] ],
		source 		=> "puppet:///modules/procmail/poisoned",
	}

	file { "/etc/procmailrc":
		ensure 		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		require		=> Package[$pkg],
		source 		=> "puppet:///modules/procmail/procmailrc",
	}

	file { "/var/log/procmail.log":
		ensure 		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 666,
		require		=> Package[$pkg],
	}

}	

