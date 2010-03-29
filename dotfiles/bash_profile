#!/usr/bin/env bash

if [[ "$OSTYPE" == darwin* ]]; then
	MAC=1
fi

BASE="$HOME/.jibberia_bash"

if [[ -d "$BASE" ]]; then
	
	for FILE in `ls $BASE/universal`; do
		FILE="$BASE/universal/$FILE"
		# echo "$FILE"
		if [[ -x "$FILE" && ! -d "$FILE" ]]; then
			source "$FILE"
		fi
	done

    set +v
	
	if [[ $MAC ]]; then
        # echo "---mac--- base = $BASE"
		# for FILE in $MAC_FILES; do
	    for FILE in `/bin/ls $BASE/mac`; do
			FILE="$BASE/mac/$FILE"
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

