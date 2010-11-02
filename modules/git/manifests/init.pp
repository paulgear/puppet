# puppet module to install git

class git {

	$pkg = $operatingsystem ? {
		centos		=> "git",
		debian		=> "git-core",
		ubuntu		=> "git-core",
	}

	package { $pkg:
		ensure		=> installed,
	}

}

