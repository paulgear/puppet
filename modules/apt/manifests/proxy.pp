# puppet define to set apt proxy

define apt::proxy (
		$proxy = "http://proxy:8080/"
		) {
	$dir = "/etc/apt"
	$conf = "$dir/apt.conf.d"

	# create separate file for proxy configuration
	file { "$conf/proxy.conf":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 644,
		content	=> "// Managed by puppet - do not edit here!
Acquire::http::Proxy \"$proxy\";\n",
	}

	# remove the guess file created by xen-tools/debootstrap
	file { "$conf/proxy-guess":
		ensure	=> absent,
	}

	# comment out any matching lines in the master config file
	text::replace_lines { "$dir/apt.conf":
		file	=> '$dir/apt.conf',
		pattern	=> '^[^/]*Acquire::http::Proxy',
		replace	=> '// \\1',
	}

}

