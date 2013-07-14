#
# class to install webmin repo and package
#
# DONE: Edited for Ubuntu compatibility
#

class webmin {

	$pkg = "webmin"
	$keyurl = "http://www.webmin.com/jcameron-key.asc"

	case $operatingsystem {

		"centos": {
			include proxy

			# define webmin yum repo
			yumrepo { $pkg:
				baseurl		=> "http://download.webmin.com/download/yum",
				descr		=> "Webmin Distribution Neutral",
				enabled		=> 1,
				gpgcheck	=> 1,
				gpgkey		=> $keyurl,
				proxy		=> absent,
			}
			package { "webmin":
				ensure		=> installed,
				require		=> Yumrepo[$pkg],
			}
		}

		"debian", "ubuntu": {
			include apt

			apt::source { $pkg:
				uri             => "http://download.webmin.com/download/repository",
				comment		=> "Webmin apt repository",
				distribution    => "sarge",
				components      => [ "contrib" ],
			}       

			package { $pkg:
				ensure          => installed,
				require         => Apt::Source[ $pkg ],
			}               

			apt::key { "11F63C51":
				ensure  => present,
			}               

		}

	}

	# for systems which use git for /etc (e.g. via etckeeper)
	$ignfile = "/etc/.gitignore"
	exec { "ignore webmin status directory":
		command		=> "echo webmin/system-status >> $ignfile",
		onlyif		=> "test -t $ignfile",
		unless		=> "grep -q '^webmin/system-status' $ignfile",
		logoutput	=> true,
	}

}

