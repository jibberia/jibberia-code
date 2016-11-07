if [[ -d "/opt/local" ]]; then
	export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
	export MANPATH="/opt/local/share/man:$MANPATH"
fi

if [[ -d "/usr/local/sbin" ]]; then
	export PATH="$PATH:/usr/local/sbin"
fi

if [[ -d "/usr/local/mysql/bin" ]]; then
	export PATH="/usr/local/mysql/bin:$PATH"
fi

export web='/Library/WebServer/Documents/'
export WEB=$web
