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
	$groups = [ "amavis", "clamav" ]
	# this relies on the fact that the user & group names are the same
	user { $groups:
		ensure		=> present,
		groups		=> $groups,
		membership	=> minimum,
		require		=> Class["amavis::package"],
	}
}

