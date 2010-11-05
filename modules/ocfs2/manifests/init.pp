# puppet class to install ocfs2
class ocfs2 {

	$packages = [ 'ocfs2-tools', 'ocfs2console' ]

	package { $packages:
		ensure	=> installed,
	}

}

