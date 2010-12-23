# puppet module to install git

class git {

	$cfg = "/root/.gitconfig"
	$pkg = $operatingsystem ? {
		centos		=> "git",
		debian		=> "git-core",
		ubuntu		=> "git-core",
	}

	package { $pkg:
		ensure		=> installed,
		notify		=> File[$cfg],
	}

	file { $cfg:
		ensure		=> present,
		content		=> "# git configuration created by puppet - customise as needed
[user]
	name = Super User
	email = root@$fqdn
",
		mode		=> 644,
		replace		=> no,
	}

}

