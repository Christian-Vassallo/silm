#!/bin/sh
# This script traces through all included files and removes their
# preprocessed dependencies.

script=$1

[ -z "$script" ] && exit 1

function remove_what_includes() {
	for x in $(egrep "^(extern\(\"${1}\"\)|#include \"${1}\")$" *.n *.nh|cut -d: -f1); do
		rm -v $x[sc]s
		remove_what_includes `echo $x |cut -d. -f1`
	done
}

remove_what_includes $script
