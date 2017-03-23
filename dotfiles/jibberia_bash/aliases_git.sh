alias gs="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gds="git diff -- '*.cs'"
alias git-rev='git rev-parse --short HEAD'
alias gh="git remote get-url origin | awk -F[:.] '{print \"https://github.com/\"\$3}' | xargs open"
alias ghb="open https://github.com/`git remote get-url origin | awk -F[:.] '{print $3}'`/tree/`git status --branch --porcelain | awk -F[\ .] '{print $2}'`"
