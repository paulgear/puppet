# enable sasl service
class sasl::service {
	$svc = "saslauthd"
	service { $svc:
		enable		=> true,
		hasrestart	=> true,
		hasstatus	=> true,
		require		=> Class["sasl::package"],
	}
	# manually enable service on Debian/Ubuntu
	case $operatingsystem {
		debian, ubuntu: {
			text::replace_lines { "/etc/default/saslauthd":
				file		=> "/etc/default/saslauthd",
				pattern		=> "^start=.*",
				replace		=> "start=yes",
				optimise	=> true,
				require		=> Class["sasl::package"],
			}
		}
	}
}
