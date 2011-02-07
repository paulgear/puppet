# puppe class to install git gui

class git::gui {
	$pkg = "git-gui"
	package { $pkg:
		ensure		=> installed,
	}
}

