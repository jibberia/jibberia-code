#!/usr/bin/env bash

# -e = both files and dirs
if [[ -e $1 ]]; then
    echo "$1 exists"
else
    echo "$1 does not exist"
fi

if [[ -f $1 ]]; then
    echo "$1 is a regular file"
else
    echo "$1 is NOT a regular file"
fi

if [[ -d $1 ]]; then
    echo "$1 is a directory"
else
    echo "$1 is NOT a directory"
fi

[ -e $1 ] && echo "special $1 exists"

# echo "====="

if [[ -x $1 ]]; then
    echo "$1 is exec"
else
    echo "$1 is NOT exec"
fi

if [[ -x $1 ]]; then
    echo "$1 is exec"
	if [[ -d $1 ]]; then
	    echo "$1 is a directory"
	else
	    echo "$1 is NOT a directory"
	fi
else
    echo "$1 is NOT exec"
fi

echo "------"

if [[ -x $1 ]] && [[ -d $1 ]]; then
    echo "$1 is exec and directory"
else
    echo "$1 is NOT exec and directory"
fi

if [[ -x $1 ]] &! [[ !-d $1 ]]; then
    echo "$1 is exec and NOT directory"
else
	echo "uh oh"
fi
