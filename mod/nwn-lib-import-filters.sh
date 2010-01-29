#!/bin/sh

modroot=$(readlink -f `dirname $0`)

echo "-r $modroot/filters/clean_locstrs.rb \
-r $modroot/filters/fix_are_version.rb \
-r $modroot/filters/remove_plac2item.rb \
-r $modroot/filters/check_area_scripts.rb \
-r $modroot/filters/fix_placed_doors.rb \
-r $modroot/filters/truncate_floats.rb \
-r $modroot/filters/fix_static.rb"
