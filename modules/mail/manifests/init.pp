#
# action to send mail
#

define send_mail( $message ) {
	exec { "mail $message":
		command		=> "sh -c 'echo $message | mail -s puppet root@localhost'",
		refreshonly	=> true,
	}
}
