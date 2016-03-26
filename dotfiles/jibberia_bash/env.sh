export PATH="$HOME/bin":$PATH
export LANG="en_US.UTF-8"
export DISPLAY=:0.0
export TERM=xterm-color
export CLICOLOR=1

export EDITOR=vim
export SVN_EDITOR=vim
# export PS1="\h:\w \u\$ "
# with hostname:
#export PS1="\h:\[\e[34m\]\w\[\e[0m\] \u$ "
# without hostname:
# export PS1="\[\e[34m\]\w\[\e[0m\] $ "
# with git branch:
export PS1="\[\e[34m\]\w\[\e[0m\]\[\e[36m\]\$(__git_ps1)\[\e[0m\] $ "

# set window title to hostname:
echo -n -e "\033]0;`hostname -s`\007"

export GREP_OPTIONS='--color=auto -E'

shopt -s extglob

# 10x history
export HISTSIZE=5000

# pip should only run if there is a virtualenv currently activated
# http://hackercodex.com/guide/python-development-environment-on-mac-osx/
# actually... let's disable this for now, but leave it here
#export PIP_REQUIRE_VIRTUALENV=true

# semi-zsh-like behavior for bash
# https://superuser.com/questions/288714/bash-autocomplete-like-zsh
# show-all-if-ambiguous seems to require a newer bash than apple's
#   and it kinda sucks without it
# not sure if I want to keep this...
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
