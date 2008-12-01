#!/bin/sh

# This script checks for common mistakes and fixes
# things that can be fixed automagically.

modroot=$(readlink -f `dirname $0`)

too_long_files=$(find $modroot -maxdepth 2 | cut -d'.' -f2 | cut -d'/' -f3- | sort -u | egrep '/.{17,}$')

[ ! -z "$too_long_files" ] && echo -e "Files that are too long:\n$too_long_files" >&2 && exit 1

exit 0
