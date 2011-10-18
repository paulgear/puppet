# puppet class to set selinux mode - may require a reboot
# valid modes: Enforcing, Permissive
define selinux::setmode( $mode ) {
	ulb { "change-selinux-mode":
		source_class	=> "selinux",
	}
	exec { "/usr/local/bin/change-selinux-mode $mode":
		logoutput	=> true,
	}
}
