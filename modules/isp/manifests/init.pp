# definitions for specific ISPs
class isp {

	case $isp {

		"iinet", "netspace": {
			$mirrorbase = "http://ftp.iinet.net.au"
			$centosbase = "$mirrorbase/pub/centos"
			$debianbase = "$mirrorbase/debian/debian"
			$debianbackports = "$mirrorbase/pub/debian-backports"
		}

		"exetel": {
			$mirrorbase = "http://mirror.exetel.com.au/"
			$centosbase = "http://mirror.aarnet.edu.au/pub/centos"
			$debianbase = "$mirrorbase/pub/debian/debian"
			$debianbackports = "$mirrorbase/pub/debian/debian-backports"
		}

		"bigpond": {
			$mirrorbase = "http://mirror.aarnet.edu.au/"
			$centosbase = "$mirrorbase/pub/centos"
			$debianbase = "$mirrorbase/pub/debian"
			$debianbackports = "http://ftp.iinet.net.au/pub/debian-backports"
		}

		default: {
			$mirrorbase = "http://ftp.au.debian.org"
			$centosbase = "http://mirror.aarnet.edu.au/pub/centos"
			$debianbase = "$mirrorbase/debian"
			$debianbackports = "$mirrorbase/backports.org"
		}

	}

}
