# puppet class to install raid repair script

class raid::repair {
	ulb { "raid-auto-repair":
		source_class => "raid",
	}
}
