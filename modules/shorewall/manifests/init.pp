#
# puppet class to install shorewall
#

class shorewall {

	$email = "root@localhost"
	$pkg = $operatingsystem ? {
		centos	=> $operatingsystemrelease ? {
			/^5/	=> "shorewall-perl",
			default	=> "shorewall",
		},
		debian	=> "shorewall",
		ubuntu	=> "shorewall",
		default	=> undef,
	}
	$svc = "shorewall"

	package { $pkg:
		ensure	=> installed,
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

	case $operatingsystem {
		debian: {
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

