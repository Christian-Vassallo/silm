#!/bin/sh

# This script checks for common mistakes and fixes
# things that can be fixed automagically.

modroot=$(readlink -f `dirname $0`)

for x in $@; do
	ext=`echo $x | tr "[:upper:]" "[:lower:]"`

	case $ext in
	*.utd.yml)
		fix-door-scripts.rb $x
		;;
	*.uti.yml)
		show-item.rb $x
		;;

	*.are.yml)
		fix-area-scripts.rb $x
		;;
	*.git.yml)
		fix-placed-doors.rb $x
		show-useables.rb $x
		;;

	*)
		echo "WARNING: Cannot verify $x; skipping."
		continue
		;;
	esac
done
