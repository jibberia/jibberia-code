#!/usr/bin/env bash

PROFILE_PATH="`pwd`/bash_profile"

if [[ -e "$PROFILE_PATH" ]]; then
	echo
	echo "Add the following line to your ~/.bash_profile"
	echo "near the top. You can then override / customize"
	echo "commands for your environment, if necessary."
	echo
	echo "source \"$PROFILE_PATH\""
	echo
    echo "Then do this:"
    echo
    echo "cp jibberia_bash/sl.txt ~/.sl.txt"
    echo
else
	echo "Run ./install.sh from your jibberia-code dotfiles directory"
	exit 1
fi

exit 0
