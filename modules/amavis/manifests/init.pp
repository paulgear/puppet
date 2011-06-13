# puppet class to manage amavisd-new

class amavis {
	include amavis::package
	include amavis::service
	include amavis::groups
	include amavis::files
}

class amavis::package {
	$pkg = "amavisd-new"
	package { $pkg:
		ensure		=> installed
	}
}

class amavis::service {
	$svc = "amavis"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["amavis::package"],
	}
}

class amavis::groups {
	include clamav
	$groups = [ "amavis", "clamav" ]
	user { "amavis":
		ensure		=> present,
		groups		=> $groups,
		membership	=> minimum,
		require		=> Class["amavis::package"],
		notify		=> Class["amavis::service"],
	}
	user { "clamav":
		ensure		=> present,
		groups		=> $groups,
		membership	=> minimum,
		require		=> Class["amavis::package"],
		notify		=> Class["clamav::service"],
	}
}

# extra utilities which enable amavis to look deeper into content
class amavis::decoders {
	$pkgs = [
		"arj",
		"cabextract",
		"lha",
		"lzop",
		"nomarch",
		"p7zip",
		"p7zip-full",
		"ripole",
		"rpm2cpio",
		"unrar-free",
		"zoo",
	]
	package { $pkgs:
		ensure	=> installed,
		notify	=> Class["amavis::service"],
	}
}

class amavis::files {
	file { "/usr/local/bin/amavis-summary":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 0755,
		source	=> "puppet:///modules/amavis/amavis-summary",
	}
	file { "/etc/cron.weekly/amavis-summary":
		ensure	=> absent,
	}
	cron_job { "amavis-summary":
		interval	=> "d",
		script		=> "# Managed by puppet on $server - do not edit locally
7 0 * * 0 root /usr/local/bin/amavis-summary
",
	}
}

