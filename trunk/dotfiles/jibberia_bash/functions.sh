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
namewindow () { echo -n -e "\033]0;"$@"\007"; }
#function pmpy { python manage.py $@ --settings=$DJANGO_SETTINGS_MODULE; }
function prefix {
    prefix="$1"
    shift
    for file in $@; do
        mv $file $prefix$file;
    done
}
