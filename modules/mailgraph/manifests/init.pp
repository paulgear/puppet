#
# puppet class to manage mailgraph
#

class mailgraph {

	$pkg = "mailgraph"

	package { $pkg:
		ensure		=> installed
	}
}


