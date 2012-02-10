# puppet module to manage crontab file on linux

# change the hour of the cron daily/weekly/monthly run
# FIXME: this rewrites the crontab file on every run
define cron::crontab ( $hour ) {
	include text
	$crontab = "/etc/crontab"
	text::replace_lines { $crontab:
		file		=> $crontab,
		pattern		=> "^([0-9]+)[ 	]+[0-9]+[ 	]+",
		replace		=> "\\1 $hour ",
	}
}
