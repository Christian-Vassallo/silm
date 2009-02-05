#!/bin/sh

# This script imports game resources into their proper
# directories within the mod structure, converting them
# appropriately.

modroot=$(readlink -f `dirname $0`)

run() {
	echo "$@"
	$@
}

for x in $@; do
	target=""
	opts=""
	ext=`echo $x | tr "[:upper:]" "[:lower:]"`
	case $ext in
	*.are) target="area" ;;
	*.git)
		target="area"
		;;
	*.ut[a-z]) target=${ext:(-3):3} ;;
	*.dlg) target="dlg" ;;
	*.ssf) target="ssf" ;;
	*)
		echo "WARNING: Cannot place $x; skipping."
		continue
		;;
	esac

	base=`basename $x | tr "[:upper:]" "[:lower:]"`
	to="$modroot/$target/$base"
	to_yml="$to.yml"

	if [ -f $to ]; then
		x_md=`md5sum $x|cut -d' ' -f1`
		to_md=`md5sum $to|cut -d' ' -f1`
		if [ "$x_md" = "$to_md" ]; then
			echo "Not importing $x: not modified."
			continue
		fi
	fi

	run nwn-gff $($modroot/nwn-lib-import-filters.sh) -i $x -ky -o $to_yml
done
