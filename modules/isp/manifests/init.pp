# definitions for specific ISPs
class isp {

	case $isp {

		"iinet": {
			$mirrorbase = "http://ftp.iinet.net.au"
			$debianbase = "$mirrorbase/debian/debian"
			$debianbackports = "$mirrorbase/pub/debian-backports"
		}

		"netspace": {
			$mirrorbase = "http://ftp.netspace.net.au"
			$debianbase = "$mirrorbase/pub/debian"
			$debianbackports = "http://mirror.linux.org.au/backports.org/"
		}

		default: {
			$mirrorbase = "http://ftp.au.debian.org"
			$debianbase = "$mirrorbase/debian"
			$debianbackports = "http://mirror.linux.org.au/backports.org/"
		}

	}

}
