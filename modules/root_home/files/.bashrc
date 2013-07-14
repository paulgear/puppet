
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
alias ckp='git commit -a -m"Checkpoint"'
alias cp='cp -i'
alias duh='du -hx --max-depth=1 |sort -n'
alias dum='du -mx --max-depth=1 |sort -n'
alias ip6='ip -6'
alias lg='lm | grep '
alias ll='ls -la'
alias lm='ls -la --color=always | more'
alias lr='lm | grep rpm'
alias lrpm='ls --color=always | grep rpm | more'
alias mv='mv -i'
case "`puppet agent --version 2>/dev/null`" in
2.6*|2.7*|3.*)
	alias kp='kill -USR1 $(cat /var/run/puppet/agent.pid)'
	alias tp='tme -n 1|grep puppet-agent'
	;;
*)
	alias kp='killall -USR1 puppetd'
	alias tp='tme -n 1|grep puppetd'
	;;
esac
alias pt='kp; tp'
alias rm='rm -i'
alias taillog='tme|grep -Evf ~/taillog.exclude'
alias td='tail -F /var/log/dansguardian/access.log'
alias tk='tail -F /var/log/sysmgt/kern'
alias tma='tail -F /var/log/sysmgt/mail'
alias tme='tail -F /var/log/sysmgt/all'
alias trad='tail -F /var/log/radius/radius.log'
alias ts='tail -F /var/log/squid/access.log'
alias vi='vim'

export EDITOR=vim
export VISUAL=vim

if [ -d $HOME/bin ]; then
	PATH=$HOME/bin:$PATH
fi

VTYSH="`which vtysh 2>/dev/null`"
if [ -x "$VTYSH" ]; then
	function show
	{
		$VTYSH -c "show $*"
	}
fi

function paul
{
	alias dir='ls -Fabl'
	alias df='df -m'
	alias more=less
	set -o vi
	export LESS=-eiMRX
}

function pdate
{
	perl -we 'print localtime($ARGV[0]) . "\n";' "$@"
}

