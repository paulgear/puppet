# /etc/puppet/manifests/site.pp

# backup server
filebucket { main:
	server => puppet
}

# global defaults:

# backup all modified files to main filebucket
File { backup => main }

# set path for all executed commands
Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin" }

# Force choice of the non-Debian service provider
if $operatingsystem == "Ubuntu" {
	Service { provider => init }
}

# global schedules
schedule { "businesshours":
	period	=> daily,
	range	=> [ "7-18" ],
	repeat	=> 24,		# run up to 22 times during the window (once every 30 minutes)
}

schedule { "outsidebusinesshours":
	period	=> daily,
	range	=> [ "0-6", "19-23" ],
	repeat	=> 2,		# run up to 2 times during the window
}

# manage cron jobs in separate files - call with enable => "false" to delete the job
define cron_job( $enable = "true", $interval = "daily", $script = "" ) {
	file { "/etc/cron.$interval/$name":
		content		=> $script,
		ensure		=> $enable ? {
			/^("false"|"off"|"no"|"0"|false|off|no|0)$/ => absent,
			default	=> file,
		},
		force		=> true,
		owner		=> root,
		group		=> root,
		mode		=> $interval ? {
			"d"	=> 644,
			default	=> 755,
		},
	}
	if $require {
		File[ "/etc/cron.$interval/$name" ] {
			require	+> $require,
		}
	}
}

define ulb( $source_class ) {
	file { "$fqdn-$source_class-$name":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 0755,
		path	=> "/usr/local/bin/$name",
		source	=> "puppet:///modules/$source_class/$name",
	}
}

import "roles"
import "sites"
import "nodes"

