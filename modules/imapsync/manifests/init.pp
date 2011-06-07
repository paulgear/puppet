# puppet class to install imapsync and related files

class imapsync {
	include imapsync::package
	include imapsync::files
}

# run imapsync script daily
class imapsync::cron {
	include imapsync::files
	cron_job { "imapsync-cron":
		interval	=> weekly,
		script		=> "#!/bin/sh
/usr/local/bin/imapsync-archive
",
		require		=> Class["imapsync::files"],
}

# script to use imapsync to archive email for a number of users
class imapsync::files {
	ulb { "imapsync-archive":
		source_class	=> imapsync,
	}
}

# install imapsync
class imapsync::package {
	$pkg = "imapsync"
	package { $pkg:
		ensure	=> installed,
	}
}

