
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
alias ckp='git commit -a -m"Checkpoint"'
alias cp='cp -i'
alias duh='du -hx --max-depth=1 |sort -n'
alias dum='du -mx --max-depth=1 |sort -n'
alias lg='lm | grep '
alias ll='ls -la'
alias lm='ls -la --color=always | more'
alias lr='lm | grep rpm'
alias lrpm='ls --color=always | grep rpm | more'
alias mv='mv -i'
alias kp='killall -USR1 puppetd'
alias pt='kp; tme -n 1|grep puppetd'
alias rm='rm -i'
alias td='tail --follow=name /var/log/dansguardian/access.log'
alias tk='tail --follow=name /var/log/kernel.log'
alias tma='tail --follow=name /var/log/maillog'
alias tme='tail --follow=name /var/log/messages'
alias tp='tme|grep puppetd'
alias trad='tail --follow=name /var/log/radius/radius.log'
alias ts='tail --follow=name /var/log/squid/access.log'
alias vi='vim'

export EDITOR=vim
export VISUAL=vim

function paul
{
	alias dir='ls -Fabl'
	alias df='df -m'
	alias more=less
	set -o vi
	export LESS=-eiMRX
}

