#
# puppet class to install shorewall
#

class shorewall {
	include shorewall::service
	include shorewall::utils
}

class shorewall::package {

	$pkg = $operatingsystem ? {
		centos	=> $operatingsystemrelease ? {
			/^5/	=> "shorewall-perl",
			default	=> "shorewall",
		},
		debian	=> "shorewall",
		ubuntu	=> "shorewall",
		default	=> undef,
	}

	package { $pkg:
		ensure	=> installed,
	}

	# Future:
	#os::debian::backports	{ "$lsbdistcodename": }

#		case $operatingsystem {
#			debian, ubuntu: {
#				# add extra Shorewall repo
#				include apt
#				apt::source { "shorewall-$lsbdistcodename-repo":
#					comment		=> "Unofficial Shorewall packages",
#					components	=> [ "main" ],
#					distribution	=> $lsbdistcodename,
#					uri		=> "http://people.connexer.com/~roberto/debian/",
#				}
#				apt::key { "63E4E277": }
#				apt::key { "B2B97BB1": }
#				apt::key { "DDA7B20F": }
#				# add this source and its keys to the requires for the package
#				Package[$pkg] {
#					require	+> [ Aptitude::Source[ "shorewall-$lsbdistcodename-repo" ], Aptitude::Key["DDA7B20F"], Aptitude::Key["B2B97BB1"] ],
#				}
#			}
#		}
#		package { $pkg:
#			ensure	=> installed,
#			require	=> $require,
#		}

}

class shorewall::service {
	$svc = "shorewall"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["shorewall::package"],
	}

	case $operatingsystem {
		debian, ubuntu: {
			# enable startup
			$defaults = "/etc/default/shorewall"
			text::replace_lines { $defaults:
				file		=> $defaults,
				pattern		=> '^startup=.*',
				replace		=> 'startup=1',
				optimise	=> true,
				notify		=> Service[$svc],
			}
		}
	}
}


class shorewall::utils {
	$email = "root@localhost"
	include shorewall::package
	file { "/usr/local/bin/shorewall-send-dump":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 750,
		require	=> Class["shorewall::package"],
		content	=> "#!/bin/bash
PATH=/usr/sbin:/sbin:/usr/bin:/bin:/usr/local/bin
shorewall reset
shorewall dump > /root/shorewall-before.txt
shorewall restart
shorewall reset
shorewall dump > /root/shorewall-after.txt
diff -u /root/shorewall-before.txt /root/shorewall-after.txt | mail -s 'Shorewall diagnostic' $email
",
	}
}

