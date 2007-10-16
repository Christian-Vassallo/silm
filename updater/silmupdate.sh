#!/bin/sh

# Note that all local edits will be lost on execute, if you keep this line.
echo "Updating ourselves. :)"
rsync -Rvz --progress -c rsync://swordcoast.net/nwn/silmupdate.sh .

echo "Updating haks .."
rsync -rRvz --progress --size-only rsync://swordcoast.net/nwn/hak/ .

echo "Updating tlks .."
rsync -rRvz --progress --size-only rsync://swordcoast.net/nwn/tlk/ .

echo "Updating portraits .."
rsync -rRvz --progress --size-only rsync://swordcoast.net/nwn/portraits/ .

echo "All done"
