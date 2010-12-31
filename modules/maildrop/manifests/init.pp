# puppet class to manage maildrop

class maildrop {
	include maildrop::package
}

class maildrop::package {
	$pkg = "maildrop"
	package { $pkg:
		ensure		=> installed,
	}
}

