# puppet class to create tbm's orion repo

class tbm {

	# include latest Marvell orion packages
	aptitude::source { "tbm":
		uri		=> "http://people.debian.org/~tbm/orion",
		distribution	=> "$lsbdistcodename",
		components	=> [ "main" ],
	}

	aptitude::key { "68FD549F":
		ensure	=> present,
	}

}

