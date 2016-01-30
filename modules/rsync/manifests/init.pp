# puppet class to install rsync and enable rsyncd

class rsync {

        $pkg = "rsync"
        $svc = "rsync"

        package { $pkg:
                ensure          => installed,
        }

        service { $svc:
                enable          => true,
                hasrestart      => true,
                hasstatus       => true,
                require         => Package[$pkg],
        }

}

# call this to enable rsyncd and allow individual applications to define stanzas in /etc/rsyncd.d
class rsync::config (
        $user = "nobody",
        $group = "nogroup",
        $timeout = 60,
        $max_connections = 10,
        $enable = "true",
        $nice = 15,
        $ionice = '',
) {
        include rsync
        file { "/etc/rsyncd.conf":
                owner           => "root",
                group           => "root",
                mode            => 0644,
                content         => template("rsync/rsyncd.conf.erb"),
                replace         => false,
                require         => Class['rsync'],
        }

        file { "/etc/default/rsync":
                owner           => "root",
                group           => "root",
                mode            => 0644,
                content         => template("rsync/rsync-defaults.erb"),
                replace         => false,
                require         => Class['rsync'],
        }

        file { "/etc/rsyncd.d":
                ensure          => directory,
                owner           => "root",
                group           => "root",
                mode            => 0755,
                require         => Class['rsync'],
        }
}

