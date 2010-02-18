#!/usr/bin/env bash

# ln -s ~/src/jibberia-code/dotfiles/.jibberia_bash .jibberia_bash
# ln -s ~/src/jibberia-code/dotfiles/.bash_profile .bash_profile


CWD=`pwd`
DIR=$(basename `pwd`)
if [ "$DIR" != "dotfiles" ]; then
    echo "wrong dir"
    exit
fi

# echo "$DIR"
# echo "$CWD"
# exit

PROFILE_FILE="$HOME/.bash_profile"

if [ -e "$PROFILE_FILE" ]; then
    if [ ! -h "$PROFILE_FILE" ]; then
        echo "~/.bash_profile is not a symlink, save backup:"
        echo "mv $PROFILE_FILE $PROFILE_FILE.someolderversion"
        mv "$PROFILE_FILE" "$PROFILE_FILE.someolderversion"
        echo "make symlink:"
        echo "ln -s $CWD/.bash_profile $HOME/.bash_profile"
        ln -s "$CWD/.bash_profile" "$HOME/.bash_profile"
    else
        echo "profile symlinks look ok, probably..."
    fi
    if [ ! -h "$HOME/.jibberia_bash" ]; then
        echo "symlinking .jibberia_bash dir:"
        echo "ln -s $CWD/.jibberia_bash $HOME/.jibberia_bash"
        ln -s "$CWD/.jibberia_bash" "$HOME/.jibberia_bash"
    else
        echo "script dir symlinks look ok, in all likelihood..."
    fi
    echo "done."
else
    echo "bad"
fi

