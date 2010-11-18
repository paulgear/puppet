# puppet class to manage sysstat utilities

class sysstat {

	$packages = [ "isag", "sysstat", ]

	package { $packages: ensure => installed }
    
	service { "sysstat":
		enable		=> true,
		hasrestart	=> true,
		require		=> Package["sysstat"],
	}

	# enable sysstat startup
	text::replace_lines { "/etc/default/sysstat":
		file	=> "/etc/default/sysstat",
		pattern	=> "^ENABLED=.*",
		replace => "ENABLED=true",
		notify	=> Service["sysstat"],
		optimise=> true,
	}

	# change sysstat history keep period
	text::replace_lines { "/etc/sysstat/sysstat":
		file	=> "/etc/sysstat/sysstat",
		pattern	=> "^HISTORY=.*",
		replace => "HISTORY=28",
		notify	=> Service["sysstat"],
		optimise=> true,
	}

}

