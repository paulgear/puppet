# puppet class to configure postgrey

class postgrey {
	include postgrey::package
	include postgrey::service
	include postgrey::make
	include postgrey::files
}

class postgrey::files {
	define postgrey_file ( $replace = false ) {
		file { "/etc/postgrey/$name":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			notify	=> Class["postgrey::make"],
			replace	=> $replace,
			source	=> "puppet:///modules/postgrey/$name",
		}
	}

	# files which are initialised but not overwritten by puppet
	$files = [ "whitelist_clients.local", "whitelist_recipients.local" ]
	postgrey_file { $files: }

	# files which are distributed by puppet
	postgrey_file { "Makefile": replace => true }
}

class postgrey::make {
	include make::package
	exec { "update postgrey databases":
		command		=> "make",
		cwd		=> "/etc/postgrey",
		logoutput	=> true,
		refreshonly	=> true,
		require		=> Class["make::package"],
	}
}

class postgrey::package {
	$pkg = "postgrey"
	package { $pkg:
		ensure		=> installed,
	}
}

class postgrey::service {
	$svc = "postgrey"
	service { $svc:
		enable		=> true,
		require		=> Class["postgrey::package"],
	}
}

