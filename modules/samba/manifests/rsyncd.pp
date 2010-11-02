#
# puppet class to enable rsyncd for samba data
#
# FIXME - Ubuntu: service enabling needs checking; may need additional
# configuration files because Ubuntu does not start rsyncd from xinetd.
#
# FIXME: Separate out generic from site-specific content.
#

class samba::rsyncd {

	require rsync

	file { "/etc/rsyncd.conf":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		require	=> Package[$pkg],
		content	=> '
# managed by puppet - do not edit locally!
syslog facility = local5
read only = yes
hosts allow = 192.168.0.0/16 10.8.0.0/24

[staff-photos]
	path = /data/staff.photos
	read only = no

',
	}

}

