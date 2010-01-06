#!/usr/bin/env bash

FILES="env aliases functions functions_vcs"
MAC_FILES="env_mac aliases_mac aliases_mac_apps functions_mac"

if [[ "$OSTYPE" == darwin* ]]; then
	MAC=1
fi

if [[ -d "$HOME/.jibberia_bash" ]]; then
	BASE="$HOME/.jibberia_bash"
	
	for FILE in $FILES; do
		FILE="$BASE/$FILE"
		# echo "$FILE"
		if [[ -x "$FILE" && ! -d "$FILE" ]]; then
			source "$FILE"
		fi
	done
	
	if [[ $MAC ]]; then
		for FILE in $MAC_FILES; do
			FILE="$BASE/$FILE"
			# echo "$FILE"
			if [[ -x "$FILE" && ! -d "$FILE" ]]; then
				source "$FILE"
			fi
		done
	fi
fi

if which fortune &> /dev/null; then
	fortune -a
fi

