# Description:	fail2ban filter to find winbind critical remote errors
# Author:	Paul Gear <puppet@libertysys.com.au>
# License:	GPLv3
# Copyright:	(c) 2010 Gear Consulting Pty Ltd <http://libertysys.com.au/>

class fail2ban::filters::winbind_remote_error {
	fail2ban::filter { "winbind-remote-error":
		failregex	=> 'rpc_api_pipe: Remote machine .*returned critical error.',
	}
}

