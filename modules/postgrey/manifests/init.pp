# puppet class to configure postgrey

class postgrey {
	include postgrey::package
	include postgrey::service
	include postgrey::files
}

class postgrey::files {
	define postgrey_file ( $replace = false ) {
		file { "/etc/postgrey/$name":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			source	=> "puppet:///modules/postgrey/$name",
			replace	=> $replace,
		}
	}
	$files = [ "whitelist_clients.local", "whitelist_recipients.local" ]
	postgrey_file { $files: }
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

