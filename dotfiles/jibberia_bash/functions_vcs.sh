function ss {
    TMP_FILE_PATH="/tmp/svn-st-$USER"
    for x in `svn stat $* | tee "$TMP_FILE_PATH" | awk '{ print "s" NR "=" $2 }'`;
    do
        export $x;
    done;
    cat -n "$TMP_FILE_PATH";
    rm "$TMP_FILE_PATH";
}
function hs {
    TMP_FILE_PATH="/tmp/hg-st-$USER"
    for x in `hg stat $* | tee "$TMP_FILE_PATH" | awk '{ print "s" NR "=" $2 }'`;
    do
        export $x;
    done;
    cat -n "$TMP_FILE_PATH";
    rm "$TMP_FILE_PATH";
}

# this might be worthwhile:
# if svn diff &> /dev/null; then echo "is svn $?"; else echo "not svn $?"; fi;
function sdfl {
    TMP_FILE_PATH="/tmp/svn-$USER.diff"
    svn diff $* > "$TMP_FILE_PATH"
    less "$TMP_FILE_PATH"
    rm "$TMP_FILE_PATH"
}
function hdfl {
    TMP_FILE_PATH="/tmp/hg-$USER.diff"
    hg diff $* > "$TMP_FILE_PATH"
    less "$TMP_FILE_PATH"
    rm "$TMP_FILE_PATH"
}
function sdfm {
    TMP_FILE_PATH="/tmp/svn-$USER.diff"
    svn diff $* > "$TMP_FILE_PATH"
    mate "$TMP_FILE_PATH"
    rm "$TMP_FILE_PATH"
}
function hdfm {
    TMP_FILE_PATH="/tmp/hg-$USER.diff"
    hg diff $* > "$TMP_FILE_PATH"
    mate "$TMP_FILE_PATH"
    rm "$TMP_FILE_PATH"
}
