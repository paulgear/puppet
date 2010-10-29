#
# puppet class to manage ADSL client interface configuration
#
# DONE: Checked for Ubuntu compatibility
#

class adsl_client {

# FIXME: use OpenDNS instead of ISP name servers

	define configure ($eth, $isp = $isp, $search) {

		$isp_ns = $isp ? {
			iinet		=> "203.0.178.191",
			onthenet	=> "203.22.124.10, 203.10.89.2",
			tpg		=> "203.12.160.35, 203.12.160.36",
		}

# FIXME - Ubuntu: different configuration of network interfaces, different location for dhclient.conf

		$basedir = "/etc"
		$sysconfig = "$basedir/sysconfig"
		$netscripts = "$sysconfig/network-scripts"
		$dhclient = "$basedir/dhclient.conf"
		$ifcfg = "$netscripts/ifcfg-$eth"
		$MAGIC = "Created by puppet - do not edit here"

		# create directories
		file { [ $basedir, $sysconfig, $netscripts ]:
			ensure	=> directory,
		}

		# create DHCP client override file
		file { $dhclient:
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			require	=> File[$basedir],
			content	=> "
retry 10;
interface \"$eth\" {
supersede domain-name \"$search\";
supersede domain-name-servers 127.0.0.1, $isp_ns;
}
",
		}

		# create ifcfg-ethX file
		exec { "ifcfg-$eth":
			command		=> "ifconfig $eth | awk '\$1 == \"$eth\" {print \"# $MAGIC\"; print \"DEVICE=\"\$1; print \"BOOTPROTO=dhcp\"; print \"ONBOOT=yes\"; print \"HWADDR=\"tolower(\$NF); exit 0; }' > $ifcfg",
			unless		=> "grep -q '^# $MAGIC' $ifcfg",
			logoutput	=> true,
			require		=> File[$netscripts],
		}

		# set permissions on ifcfg-ethX file
		file { $ifcfg:
			ensure		=> file,
			owner		=> root,
			group		=> root,
			mode		=> 644,
			require		=> Exec["ifcfg-$eth"],
		}

	}

}

