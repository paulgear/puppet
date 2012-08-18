# puppet class to install webalizer

class webalizer {
	include webalizer::package
}

# install package
class webalizer::package {
	$pkg = "webalizer"
	package { $pkg:
		ensure		=> installed,
	}
}

