#
# puppet class to set proxy server appropriately
#
# DONE: Checked for Ubuntu compatibility
#

class proxy {

	if defined(Class["squid"]) {
		$proxy = "http://localhost:3128/"
	}
	else {
		if $dmz {
			$proxy = undef
		}
		else {
			$proxy = "http://proxy:8080/"
		}
	}

	info("Proxy for $fqdn is $proxy::proxy")

}
