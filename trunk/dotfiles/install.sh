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

if [ -e "$HOME/.bash_profile" ]; then
    echo "mv ~/.bash_profile ~/.bash_profile.not"
    mv "$HOME/.bash_profile" "$HOME/.bash_profile.not"
    echo "make symlinks..."
    ln -s "$CWD/.bash_profile" "$HOME/.bash_profile"
    ln -s "$CWD/.jibberia_bash" "$HOME/.jibberia_bash"
    echo "done."
else
    echo "bad"
fi

