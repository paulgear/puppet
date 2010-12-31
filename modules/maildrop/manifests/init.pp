# puppet class to manage maildrop

class maildrop {
	include maildrop::package
	include maildrop::config
}

class maildrop::package {
	$pkg = "maildrop"
	package { $pkg:
		ensure		=> installed,
	}
}

# ensure maildrop delivers to maildirs
class maildrop::config {
	$cfg = "/etc/maildroprc"
	text::replace_lines { $cfg:
		file		=> $cfg,
		pattern		=> '^#?DEFAULT=.*',
		replace		=> 'DEFAULT="$HOME/Maildir"',
		optimise	=> true,
		require		=> Class["maildrop::package"],
	}
}

