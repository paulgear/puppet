#
# puppet class to install shorewall
#

class shorewall {

	$email = "root@localhost"
	$pkg = "shorewall"

	package { $pkg:
		ensure	=> installed,
	}

	case $lsbdistcodename {
		lenny: {
			# if Debian lenny, add extra repo
			include aptitude

			aptitude::source { "shorewall-$lsbdistcodename-repo":
				comment		=> "Unofficial Shorewall packages",
				components	=> [ "main" ],
				distribution	=> $lsbdistcodename,
				uri		=> "http://people.connexer.com/~roberto/debian/",
			}

			aptitude::key { "B2B97BB1": }

			# add this source to the requires for the package
			Package[$pkg] {
				require	+> Aptitude::Source[ "shorewall-$lsbdistcodename-repo" ],
			}
		}
	}

	file { "/usr/local/bin/shorewall-send-dump":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 750,
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

