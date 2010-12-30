#
# puppet class to manage amavisd-new
#

class amavis {
	include amavis::package
	include amavis::groups
}

class amavis::package {
	$pkg = "amavisd-new"
	package { $pkg:
		ensure		=> installed
	}
}

class amavis::groups {
	$group = [ "amavis", "clamav" ]
	user { "amavis":
		groups		=> $groups,
		membership	=> minimum,
		require		=> Class["amavis::package"],
	}
	user { "clamav":
		groups		=> $groups,
		membership	=> minimum,
		require		=> Class["amavis::package"],
	}
}

