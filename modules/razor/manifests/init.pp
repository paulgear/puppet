# puppet class to install razor

class razor {
	include razor::package
	include razor::logging
}

# set razor to log using syslog
class razor::logging {
	$file = "/etc/razor/razor-agent.conf"
	text::replace_lines { $file:
		file		=> $file,
		pattern		=> '^logfile = .*',
		replace		=> 'logfile = sys-syslog',
		optimise	=> true,
		require		=> Class["razor::package"],
	}
}

class razor::package {
	$pkg = "razor"
	package { $pkg:
		ensure	=> installed,
	}
}

