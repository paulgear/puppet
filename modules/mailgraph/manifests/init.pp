#
# puppet class to manage mailgraph
#

class mailgraph {
	include mailgraph::package
	include mailgraph::service
	include mailgraph::cronrestart
}

class mailgraph::package {
	$pkg = "mailgraph"
	package { $pkg:
		ensure		=> installed
	}
}

class mailgraph::service {
	$svc = "mailgraph"
	service { $svc:
		enable		=> true,
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> Class["mailgraph::package"],
	}

	# manually enable on Debian/Ubuntu
	case $operatingsystem {
		debian, ubuntu: {
			text::replace_lines { "/etc/default/mailgraph":
				file		=> "/etc/default/mailgraph",
				pattern		=> "^BOOT_START=.*",
				replace		=> "BOOT_START=true",
				optimise	=> true,
				notify		=> Service[$svc],
				require		=> Class["mailgraph::package"],
			}
		}
	}
}

class mailgraph::cronrestart {
	cron_job { "000-puppet-mailgraph-restart":
		interval	=> "hourly",
		script		=> "#!/bin/sh
/usr/sbin/service
",
	}
	cron_job { "mailgraph-restart":
		enable		=> false,
	}
}

