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

alias quote='sed "s|^\(.*\)$|\"\1\"|g"'

TREE_PATH=`which tree 2> /dev/null`
if [[ -x $TREE_PATH ]]; then
	LESS_PATH=`which less`

	alias t="$TREE_PATH -C"
	alias tree="$TREE_PATH -C"
	alias tl="$TREE_PATH | $LESS_PATH"

	alias tal="$TREE_PATH -a | $LESS_PATH"
	alias treeal="$TREE_PATH -a | $LESS_PATH"
	alias tla="$TREE_PATH -a | $LESS_PATH"
	
	# for (( i = 1; i <= 6; i++ )); do
	for i in {1..6} ; do
		alias t$i="$TREE_PATH -C -L $i"
		alias tree$i="$TREE_PATH -C -L $i"
		alias tl$i="$TREE_PATH -L $i | $LESS_PATH"

		alias t$i\l="$TREE_PATH -L $i | $LESS_PATH"
		alias treel$i="$TREE_PATH -L $i | $LESS_PATH"
		alias tree$i\l="$TREE_PATH -L $i | $LESS_PATH"

		alias ta$i="$TREE_PATH -C -a -L $i"
		alias ta$i\l="$TREE_PATH -a -L $i | $LESS_PATH"
		alias tal$i="$TREE_PATH -a -L $i | $LESS_PATH"
		alias treeal$i="$TREE_PATH -a -L $i | $LESS_PATH"
		alias treea$i\l="$TREE_PATH -a -L $i | $LESS_PATH"
	done
	
	unset i LESS_PATH
fi
unset TREE_PATH

# TODO make sl a function
alias sl='cat ~/.sl.txt'

# django-admin is like manage.py but better -- it respects the DJANGO_SETTINGS_MODULE environment var.
# only downside is that it may not be on $PATH.
# TODO check whether django-admin.py is on path, if not use manage.py
# on second thought, this seems to change per project... i could do something with
# DJANGO_SETTINGS_MODULE but, y'know... just set it in ~/.bash_profile
# alias pmpy='python manage.py'
# alias pmpy='django-admin.py'

alias irb='irb --readline -r irb/completion'

alias date-time="date +\"%H:%M:%S\""
alias date-timestamp="date +\"%s\""
alias datefromtimestamp="date -r"

alias tail-httpd='sudo tail -f /var/log/httpd/access_log /var/log/httpd/error_log | egrep -v "favicon|^==|^$"'
alias apachectltestandrestart='echo "Testing apache config syntax..."; sudo apachectl configtest && ((echo "Restarting apache..."; sudo apachectl restart) && echo "done" || echo "Apache restart failed.")'

alias myip="curl www.whatismyip.com/automation/n09230945.asp && echo"

alias svnupdry="svn merge --dry-run -r BASE:HEAD ."
alias hgupdry="hg st --rev .:tip"

alias activate="source bin/activate"

# complete -C "perl -le'\$p=qq#^\$ARGV[1]#;@ARGV=q#$HOME/.ssh/config#;/\$p/&&/^\D/&&not(/[*?]/)&&print for map{split/\s+/}grep{s/^\s*Host(?:Name)?\s+//i}<>'" ssh

