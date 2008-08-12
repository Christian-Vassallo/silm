#!/bin/sh

# This script imports game resources into their proper
# directories within the mod structure, converting them
# appropriately.

modroot=$(readlink -f `dirname $0`)
echo "we are at: $modroot"

for x in $@; do
	target=""
	opts=""
	case `echo $x | tr "[:upper:]" "[:lower:]"` in
	*.are | *.gic) target="area" ;;
	*.git)
		target="area"
		opts="--float_rounding 4"
		;;
	*.ut[a-z]) target=${x:(-7):3} ;;
	*.dlg) target="dlg" ;;
	*.ssf) target="ssf" ;;
	*)
		echo "WARNING: Cannot place $x; skipping."
		continue
		;;
	esac

	base=`basename $x | tr "[:upper:]" "[:lower:]"`
	to="$modroot/$target/$base.yml"
	echo "$x -> $to"
	nwn-gff-print -y $opts $x > $to
done
