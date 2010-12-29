# definitions for specific ISPs
class isp {

	case $isp {

		"iinet", "netspace": {
			$mirrorbase = "http://ftp.iinet.net.au"
			$debianbase = "$mirrorbase/debian/debian"
			$debianbackports = "$mirrorbase/pub/debian-backports"
		}

		default: {
			$mirrorbase = "http://ftp.au.debian.org"
			$debianbase = "$mirrorbase/debian"
			$debianbackports = "$mirrorbase/backports.org"
		}

	}

}
