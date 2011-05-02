# hostname utilities for puppet

# fixes default hostname entry on Debian, which has no fqdn present
class hostname::setfqdn {
	host { $fqdn:
		ensure	=> present,
		alias	=> [ $hostname ],
		ip	=> '127.0.1.1',
	}
	host { $hostname:
		ensure	=> absent,
		ip	=> '127.0.1.1',
	}
}

