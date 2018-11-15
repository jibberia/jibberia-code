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

sl () {
cat << EOF
                                                  ____
       ___                                      .-~. /_"-._
      \`-._~-.          YOU MEANT \`ls\`          / /_ "~o\  :Y
          \  \                                / : \~x.  \` ')
           ]  Y                              /  |  Y< ~-.__j
          /   !                        _.--~T : l  l<  /.-~
         /   /                 ____.--~ .   \` l /~\ \<|Y
        /   /             .-~~"        /| .    ',-~\ \L|
       /   /             /     .^   \ Y~Y \.^>/l_   "--'
      /   Y           .-"(  .  l__  j_j l_/ /~_.-~    .
     Y    l          /    \  )    ~~~." / \`/"~ / \.__/l_
     |     \     _.-"      ~-{__     l  :  l._Z~-.___.--~
     |      ~---~           /   ~~"---\_  ' __[>
     l  .                _.^   ___     _>-y~
      \  \     .      .-~   .-~   ~>--"  /
       \  ~---"            /     ./  _.-'
        "-.,_____.,_  _.--~\     _.-~
                    ~~     (   _} 
                           \`. ~(
                             )  \\
                            /,\`--'~\--'~\\
EOF
}

function pull-latest-screenshot {
    filename="$(adb shell 'ls -t /sdcard/DCIM/Screenshots' | head -1)"
    adb pull "$(echo -n /sdcard/DCIM/Screenshots/$filename)"
    echo "open $filename"
}

function pull-latest-dcim {
    filename="$(adb shell 'ls -t /sdcard/DCIM' | head -1)"
    adb pull "$(echo -n /sdcard/DCIM/filename)"
    echo "open $filename"
}
