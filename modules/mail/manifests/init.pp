# puppet mail utilities

# action to send mail
define send_mail( $message ) {
	exec { "mail $message":
		command		=> "sh -c 'echo $message | mail -s puppet root@localhost'",
		refreshonly	=> true,
	}
}

# run newaliases whenever an alias is added
class mail::newaliases {
	include mail::newaliases::exec
	Mailalias {
		notify => Class["mail::newaliases::exec"],
	}
}

class mail::newaliases::exec {
	exec { "newaliases":
		logoutput	=> on_failure,
		refreshonly	=> true,
	}
}

