#
# puppet class to ensure that grub is set to boot the first installed kernel
#
# FIXME - Ubuntu: obsolete
#

class grub::default {

	$grubfile = "/boot/grub/menu.lst"

	exec { "edit-grub-menu.lst":
		command	=> "sed -ie 's/^default=.*$/default=0/' $grubfile",
		onlyif	=> "grep -q '^default=[^0]' $grubfile",
	}

}

