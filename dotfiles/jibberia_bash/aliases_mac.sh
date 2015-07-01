alias m='mate'

unalias ls
alias ls='ls -F'

alias mdf='mdfind -onlyin "`pwd`"'
alias mdff='mdfind -onlyin "`pwd`" -filename'
alias cdweb='cd /Library/WebServer/Documents/'

alias play='osascript -e "tell application \"iTunes\" to play"'
alias pause='osascript -e "tell application \"iTunes\" to pause"'
alias next='osascript -e "tell application \"iTunes\" to next track"'
alias prev='osascript -e "tell application \"iTunes\" to previous track"'

alias mh='sed "s/\\\040/ /g" /Users/kevin/.mysql_history'

alias plisteditor='open -a "Property List Editor"'

# To create the locate database (/var/db/locate.database):
# sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
