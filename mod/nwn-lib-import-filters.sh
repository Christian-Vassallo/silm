#!/bin/sh

modroot=$(readlink -f `dirname $0`)

echo "-r $modroot/filters/clean_locstrs.rb \
-r $modroot/filters/fix_are_version.rb \
-r $modroot/filters/check_area_scripts.rb \
-r $modroot/filters/truncate_floats.rb"
