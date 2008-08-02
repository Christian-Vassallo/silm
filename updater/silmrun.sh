#!/bin/sh

# Note that all local edits will be lost on execute, if you keep this line.
echo "Updating ourselves. :)"
rsync -Rvz --progress -c rsync://swordcoast.net/nwn/silmrun.sh .

echo "Updating haks .."
rsync -rRvz --progress --size-only rsync://swordcoast.net/nwn/hak/ .

echo "Updating tlks .."
rsync -rRvz --progress --size-only rsync://swordcoast.net/nwn/tlk/ .

echo "Updating portraits .."
rsync -rRvz --progress --size-only rsync://swordcoast.net/nwn/portraits/ .

echo "All done, starting NWN for you "
# For some reason, this does not work on linux, but on win32
#./nwn +connect swordcoast.net:5121 $@
./nwn $@
