# puppet module to install ruby on rails
class rails {
	include rails::package
}

class rails::package {
	$pkg = $operatingsystem ? {
		debian	=> "rails",
		default	=> "rails",
	}
	package { $pkg:
		ensure	=> installed,
	}
}

