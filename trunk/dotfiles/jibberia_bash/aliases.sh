# alias less=/usr/share/vim/vim72/macros/less.sh
# alias less="/usr/share/vim/**/macros/less.sh"
# alias less=/usr/share/vim/**/macros/less.sh
alias less="`ls /usr/share/vim/**/macros/less.sh | sort -n | tail -1`"

alias ls='ls -F --color'
alias ll='ls -l'
alias llt='ll -t'
alias lt='llt'
alias lth='llt | head'
alias lsl='ll -a'

alias tl='`which tree` | `which less`'
alias tree='tree -C'

# TODO make sl a function
# alias sl='cat /Users/kevin/.sl.txt'

alias ipython='ipython -noconfirm_exit'
alias pmpy='python manage.py' # 'django-admin.py'
alias irb='irb --readline -r irb/completion'

alias date-time="date +\"%H:%M:%S\""
alias date-timestamp="date +\"%s\""
alias datefromtimestamp="date -r"

alias tail-httpd='sudo tail -f /var/log/httpd/access_log /var/log/httpd/error_log | egrep -v "favicon|^==|^$"'

alias myip="curl www.whatismyip.com/automation/n09230945.asp && echo"

# complete -C "perl -le'\$p=qq#^\$ARGV[1]#;@ARGV=q#$HOME/.ssh/config#;/\$p/&&/^\D/&&not(/[*?]/)&&print for map{split/\s+/}grep{s/^\s*Host(?:Name)?\s+//i}<>'" ssh

