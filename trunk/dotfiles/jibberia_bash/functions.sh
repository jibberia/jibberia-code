pcol() {
    cols=""
    for arg in $@; do
        cols="$cols \$$arg \"\t\""
    done;
    cols=`echo $cols | sed "s/\(.*\) \"\\\t\"$/\1/"`
    awk "{print $cols}"
}
echon() { echo $1 | tr ":" "\n" ; }
function mx {
    touch "$1" && chmod +x "$1"
}
function vx {
    touch "$1" && chmod +x "$1" && vim "$1"
}
