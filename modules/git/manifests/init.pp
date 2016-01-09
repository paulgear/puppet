# puppet module to install git

class git {
	git::config { "user.name":
		value		=> "Super User",
		overwrite	=> false,
	}
	git::config { "user.email":
		value		=> "root@$fqdn",
		overwrite	=> false,
	}
}

class git::install {
	package { "git":
		ensure		=> installed,
	}
}

class git::config (
	$overwrite = true,
	$value,
) {
	include git::install
	exec { "git::config::$name":
		command	=> "git config --global $name $value",
		onlyif	=> "test $overwrite = true",
		unless	=> "test $(git config --get $name) = $value",
		require	=> Class["git::install"],
	}
}
