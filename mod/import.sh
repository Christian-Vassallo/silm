#!/bin/sh

# This script imports game resources into their proper
# directories within the mod structure, converting them
# appropriately.

modroot=$(readlink -f `dirname $0`)
echo "we are at: $modroot"

for x in $@; do
	target=""
	opts=""
	ext=`echo $x | tr "[:upper:]" "[:lower:]"`
	case $ext in
	*.are) target="area" ;;
	*.git)
		target="area"
		opts="--float_rounding 4"
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
	x_md=`md5sum $x|cut -d' ' -f1`
	to_md=`md5sum $to|cut -d' ' -f1`

	if [ -f $to ]; then
		if [ "$x_md" = "$to_md" ]; then
			echo "Not importing $x: not modified."
			continue
		fi
	fi

	echo "$x -> $to_yml"
	nwn-gff-print -y $opts $x > $to_yml

	$modroot/verify.sh $to_yml
done
