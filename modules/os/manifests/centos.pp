# centos-specific configuration

class os::centos {
	# assume all services have a restart and a status
	Service {
		hasrestart	=> true,
		hasstatus	=> true,
	}
}

class os::centos::packages {
	$packages = [ 'lsscsi', 'screen', 'strace', 'vim-enhanced', 'wireshark', ]

	package { $packages:
		ensure	=> installed,
	}
}

define os::centos::initstyle ( $style = "color" ) {
	include text
	$file = "/etc/sysconfig/init"
	text::replace_add_line { $file:
		file		=> $file,
		pattern		=> "^BOOTUP=",
		line		=> "BOOTUP=$style",
	}
}

class os::centos::yumrepos {
	include isp

	$default_repo_file = "/etc/yum.repos.d/CentOS-Base"
	$repobase = "$isp::mirrorbase/$operatingsystemrelease"

	file { $default_repo_file:
		ensure		=> absent,
	}

	yumrepo { "centos-base-puppet":
		baseurl		=> "$repobase/os/$architecture/",
		enabled		=> 1,
		gpgcheck	=> 1,
		gpgkey		=> "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6",
		mirrorlist	=> absent,
		require		=> File[$default_repo_file],
	}

	yumrepo { "centos-updates-puppet":
		baseurl		=> "$repobase/updates/$architecture/",
		enabled		=> 1,
		gpgcheck	=> 1,
		gpgkey		=> "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6",
		mirrorlist	=> absent,
		require		=> File[$default_repo_file],
	}

	yumrepo { "centos-extras-puppet":
		baseurl		=> "$repobase/extras/$architecture/",
		enabled		=> 1,
		gpgcheck	=> 1,
		gpgkey		=> "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6",
		mirrorlist	=> absent,
		require		=> File[$default_repo_file],
	}

	yumrepo { "centos-centosplus-puppet":
		baseurl		=> "$repobase/centosplus/$architecture/",
		enabled		=> 0,
		gpgcheck	=> 1,
		gpgkey		=> "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6",
		mirrorlist	=> absent,
		require		=> File[$default_repo_file],
	}

	yumrepo { "centos-contrib-puppet":
		baseurl		=> "$repobase/contrib/$architecture/",
		enabled		=> 0,
		gpgcheck	=> 1,
		gpgkey		=> "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6",
		mirrorlist	=> absent,
		require		=> File[$default_repo_file],
	}

}

