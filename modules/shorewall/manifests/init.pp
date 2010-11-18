#
# puppet class to install shorewall
#

class shorewall {

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

}
