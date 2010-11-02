#
# Manage puppet server configuration
#
# DONE: Checked for Ubuntu compatibility
#

class puppet::server_conf {

	$user = "puppet"
	$group = "support"
	$mailto = "root@localhost"

	# Checkpoint puppet configuration in subversion
	cron_job { "puppet-checkpoint":
		script		=> "#!/bin/sh
/usr/local/bin/puppet-checkpoint-git
",
	}

	# Correct ownership on puppet dir
	cron_job { "puppet-chown":
		interval	=> "hourly",
		script		=> "#!/bin/sh
# Managed by puppet - do not edit manually!
cd /etc/puppet
chown -R $user .
chgrp -R $group .
chmod -R g=u .
find . -type d -print0 | xargs chmod g+s
",
	}

	# restart puppet master server daily
	cron_job { "puppetmaster-restart":
		interval	=> "daily",
		script		=> "#!/bin/sh
/etc/init.d/puppetmaster restart
",
	}

	# report on missing clients daily
	cron_job { "puppetlast":
		interval	=> "daily",
		script		=> "#!/bin/sh
(
echo 'Puppet nodes not contacting master in the last 40 minutes'
echo '---------------------------------------------------------'
/etc/puppet/puppetlast --sort=time |awk '\$2 > 40'
) | mail -s 'Puppet nodes report' $mailto
",
	}

	# script to checkpoint configuration
	file { "/usr/local/bin/puppet-checkpoint-git":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/puppet/puppet-checkpoint-git",
		require	=> Package["git"],
	}

}

