# puppet class to install logfile tailer exclusions

class taillog {

	file { "/root/taillog.exclude":
		owner	=> root,
		group	=> root,
		mode	=> 644,
		ensure	=> file,
		source	=> "puppet:///modules/taillog/taillog.exclude",
	}

}
