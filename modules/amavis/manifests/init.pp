#
# puppet class to manage amavisd-new
#

class amavis {

	$pkg = "amavisd-new"

	package { $pkg:
		ensure		=> installed
	}
}

