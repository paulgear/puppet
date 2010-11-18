#
# puppet class to manage LVM-based backups
#

class backup::lvm {

	file { "/usr/local/bin/lvm-snapshot-mount":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/backup/bin/lvm-snapshot-mount",
	}

	# symlink lvm-snapshot to lvm-snapshot-mount
	file { "/usr/local/bin/lvm-snapshot":
		ensure	=> "/usr/local/bin/lvm-snapshot-mount",
	}

	file { "/usr/local/bin/xen-backup":
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> 755,
		source	=> "puppet:///modules/backup/bin/xen-backup",
	}

	# define lvm snapshot withOUT mount
	define lvm_snapshot( $original_lv, $snapshot_lv, $snapshot_size, $pre_remove = "", $pre_snap = "", $post_snap = "" ) {
		file { "/usr/local/etc/lvm-snapshot.conf":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			content	=> "# Managed by puppet - do not edit here!
ORIGINAL_LV='$original_lv'
SNAPSHOT_LV='$snapshot_lv'
SNAPSHOT_SIZE='$snapshot_size'
PRE_REMOVE='$pre_remove'
PRE_SNAP='$pre_snap'
POST_SNAP='$post_snap'
",
		}
	}

	# define lvm snapshot WITH mount
	define snapshot_conf( $original_dir, $original_lv, $snapshot_dir, $snapshot_lv, $snapshot_size, $pre_remove = "", $pre_snap = "", $post_snap = "" ) {
		file { "/usr/local/etc/lvm-snapshot-mount.conf":
			ensure	=> file,
			owner	=> root,
			group	=> root,
			mode	=> 644,
			content	=> "# Managed by puppet - do not edit here!
ORIGINAL_DIR='$original_dir'
ORIGINAL_LV='$original_lv'
SNAPSHOT_DIR='$snapshot_dir'
SNAPSHOT_LV='$snapshot_lv'
SNAPSHOT_SIZE='$snapshot_size'
PRE_REMOVE='$pre_remove'
PRE_SNAP='$pre_snap'
POST_SNAP='$post_snap'
",
		}
	}

}

