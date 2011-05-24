# puppet class to install raid repair script

class raid::repair {
	ulb { "raid-auto-repair":
		source_class => "raid",
	}
}

class raid::repair::weekly {
	include raid::repair
	# this can take a while, so we run it at the end of the weekly run
	cron_job { "zzzzz-puppet-raid-auto-repair":
		require		=> Class["raid::repair"],
		interval	=> "weekly",
		script		=> "#!/bin/sh
/usr/local/bin/raid-auto-repair
",
	}
	file { "/etc/cron.daily/zzzzz-puppet-raid-auto-repair":
		ensure		=> absent,
	}
}

