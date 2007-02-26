#!/bin/sh

RPASS=$1

set -e

if [ "$RPASS"x = "x" ]; then
	echo "Syntax: $0 remotepass"
	exit 1
fi

ssh root@t mysqldump -usilm_nwserver -p${RPASS} \
	--add-drop-table \
	-c -e -l  silm_nwserver | mysql -uroot nwserver
