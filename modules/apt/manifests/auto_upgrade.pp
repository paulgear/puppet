# puppet class to control apt automatic upgrades

class apt::auto_upgrade {

	case $operatingsystem {

		debian, ubuntu: {
			$pkg = "update-notifier-common"
			$pkgs = [ $pkg, "unattended-upgrades" ]

			package { $pkgs:
				ensure	=> installed,
			}

			file { "/etc/apt/apt.conf.d/10periodic":
				ensure	=> file,
				owner	=> root,
				group	=> root,
				mode	=> 644,
				content	=> '// Created by puppet - do not edit here
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Update-Package-Lists "1";
',
				require	=> Package[$pkg],
			}

		}

	}

}
