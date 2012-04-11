# puppet configuration to manage data directories which are updated from a central server

class samba::datadirs {

	# directories which must be world writable
	$rwdirs = [ "", ] 
	file { $rwdirs:
		ensure		=> directory,
		owner		=> root,
		group		=> root,
		mode		=> 777,
	}

	# create a data directory and its update job
	define data_directory( $minute, $hour, $dest, $server = "", $extra = "", $sleep = 300 ) {
		file { "$dest":
			ensure		=> directory,
			require		=> [ Package[$samba::base::packagename], File["/usr/local/bin/randomsleep"] ],
		}
		cron_job { "samba-$name-update":
			interval	=> "d",
			script		=> "# Managed by puppet on $servername - do not edit here
$minute $hour * * * root /usr/local/bin/randomsleep $sleep; rsync -az $extra $server::$name \"$dest\"/ 2>&1 | logger -p local0.info -t rsync
",
		}
	}

}
