#
# Puppet example class for SpamAssassin
#
# DONE: Edited for Ubuntu compatibility
#

class spamassassin {

	# determine package, service, and directory names
	$pkg = "spamassassin"
	$svc = "spamassassin"
	$dir = $operatingsystem ? {
		centos		=> "/etc/mail/spamassassin",
		redhat		=> "/etc/mail/spamassassin",
		default		=> "/etc/spamassassin",
	}

	package { $pkg:
		ensure		=> installed,
	}

	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Package[$pkg],
	}

	$trusted_networks = [
	]
	$whitelist_from = [
	]

	$templatedir = "/etc/puppet/modules/spamassassin/templates"
	file { "$dir/local.cf":
		require		=> Package[$pkg],	# make sure the package is installed before creating this file
		notify		=> Service[$svc],	# make sure the service is restarted after changing this file
		ensure		=> file,
		owner		=> root,
		group		=> root,
		mode		=> 644,
		content		=> template("spamassassin/local.cf.erb"),
	}

	# enable nightly spamassassin rule updates
	case $operatingsystem {
		centos: {
			cron_job { "spamassassin-rule-update":
				interval	=> daily,
				script		=> '#!/bin/sh
/usr/share/spamassassin/sa-update.cron
',
			}
		}
		debian, ubuntu: {
			$default_file = "/etc/default/spamassassin"
			exec { "spamassassin-rule-update":
				command	=> "sed -i.BAK -e 's/\\(CRON\\|ENABLED\\)=0/\\1=1/' $default_file",
				onlyif	=> "grep -e CRON=0 -e ENABLED=0 $default_file",
				notify	=> Service[$svc],
			}
		}
	}

}

