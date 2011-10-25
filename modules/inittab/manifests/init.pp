# puppet module to mangle inittab
define inittab::setdefault( $level ) {
	include text
	text::replace_lines { "set default runlevel":
		file		=> "/etc/inittab",
		pattern		=> "^id:[^:]*:initdefault:",
		replace		=> "id:$level:initdefault:",
		optimise	=> true,
	}
	
}

define inittab::ctrlaltdel( $enable ) {
	include text
	if $enable {
		text::replace_lines { "enable ctrlaltdel":
			file		=> "/etc/inittab",
			pattern		=> "^#.*ca::ctrlaltdel:",
			replace		=> "ca::ctrlaltdel:",
		}
	}
	else {
		text::comment_lines { "disable ctrlaltdel":
			file		=> "/etc/inittab",
			pattern		=> "^ca::ctrlaltdel:",
		}
	]
}

