# puppet module to mangle inittab - tested only on CentOS 5

class inittab::notify {
	exec { "/sbin/telinit q":
		logoutput	=> true,
		refreshonly	=> true,
	}
}

define inittab::setdefault( $level ) {
	include text
	text::replace_lines { "set default runlevel":
		file		=> "/etc/inittab",
		pattern		=> "^id:[^:]*:initdefault:",
		replace		=> "id:$level:initdefault:",
		optimise	=> true,
		notify		=> Class["inittab::notify"],
	}
	
}

define inittab::ctrlaltdel( $enable ) {
	include text
	if $enable {
		text::replace_lines { "enable ctrlaltdel":
			file		=> "/etc/inittab",
			pattern		=> "^#.*ca::ctrlaltdel:",
			replace		=> "ca::ctrlaltdel:",
			notify		=> Class["inittab::notify"],
		}
	} else {
		text::comment_lines { "disable ctrlaltdel":
			file		=> "/etc/inittab",
			pattern		=> "^ca::ctrlaltdel:",
			notify		=> Class["inittab::notify"],
		}
	}
}

