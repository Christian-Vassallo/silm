#!/bin/sh

RPASS=$1
LPASS=$0

set -e

if [ "$RPASS"x = "x" ]; then
	echo "Syntax: $0 localpass remotepass"
	exit 1
fi

echo "drop database nwserver" | mysql -uroot -p${LPASS}

ssh root@t mysqldump -uroot -p${RPASS} \
	--add-drop-database \
	-c -e -l  silm_nwserver | mysql -uroot -p${LPASS}
