#
# Some basic utilities
#
# DONE: Edited for Ubuntu compatibility
#

class utils {
	if ($operatingsystem == "CentOS") {

		# define rpmforge yum repo
		yumrepo { "rpmforge":
			baseurl		=> 'http://apt.sw.be/redhat/el5/en/$basearch/rpmforge',
			descr		=> 'Red Hat Enterprise $releasever - RPMforge.net - dag',
			enabled		=> 1,
			includepkgs	=> 'clam*,sarg*,memtester*',
			gpgcheck	=> 1,
			gpgkey		=> 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
			mirrorlist	=> 'http://apt.sw.be/redhat/el5/en/mirrors-rpmforge',
			protect		=> 0,
		}

		# define EPEL yum repo
		yumrepo { "epel":
			baseurl		=> absent,
			descr		=> 'Extra Packages for Enterprise Linux 5 - $basearch',
			enabled		=> 1,
			gpgcheck	=> 1,
			gpgkey		=> 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
			mirrorlist	=> 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch',
			protect		=> 0,
			includepkgs	=> 'fail2ban*,git*,lzo*,openvpn*',
	#failovermethod=priority
		}

	}

	# utility scripts
	define ulb_file () {
		file { "/usr/local/bin/$name":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 755,
			source	=> "puppet:///modules/utils/$name",
		}
	}
	ulb_file { [ 'check-kernel-version', 'fix-tun-devices', 'randomsleep', 'upgrade-dansguardian' ]: }

}

