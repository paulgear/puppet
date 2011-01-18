# puppet class to install simple squid redirector

class squid::redirect {

	file { "/usr/local/bin/simple-redirect":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/squid/simple-redirect",
	}

}
