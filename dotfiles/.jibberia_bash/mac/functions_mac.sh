trash() { mv $@ ~/.Trash/ ; }
trashq() { mv "$@" ~/.Trash/ ; }
google() {
    query=''
    for arg in $@; do
        query="$query%20$arg"
    done;
    open -a "Safari" "http://www.google.com/search?q=$query"
}
safari () {
    url=$1
    if [[ ! "$url" =~ "http://.*" ]]
    then
        url="http://$url"
    fi
    open -a "Safari.app" $url ;
}
function mxm {
    touch "$1" && chmod +x "$1" && mate "$1"
}
