# puppet class to create tbm's orion repo

class tbm {

	# include latest Marvell orion packages
	apt::source { "tbm":
		comment		=> "Kernel packages for Marvell-based ARM systems",
		uri		=> "http://people.debian.org/~tbm/orion",
		distribution	=> "$lsbdistcodename",
		components	=> [ "main" ],
	}

	apt::key { "68FD549F":
		ensure	=> present,
	}

}

