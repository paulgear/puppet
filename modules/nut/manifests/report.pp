# puppet class to run a report on UPS activity

class nut::report {

	$mailto = "root@localhost"

	file { "/usr/local/bin/nut-report":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/nut/nut-report.sh",
	}

	cron_job { "000-nut-report":
		# Beware!  Here be quoting dragons.
		script	=> "#!/bin/sh
set -e
set -u
if [ `date +%w` = 0 ]; then
	TMPFILE=`mktemp`
	/usr/local/bin/nut-report >\$TMPFILE 2>&1
	test -s \$TMPFILE && mail -s 'Weekly UPS report' $mailto < \$TMPFILE
fi
",
	}

}

