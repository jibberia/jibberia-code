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

shopt -s extglob

