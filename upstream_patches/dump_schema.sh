#!/bin/sh

S=$1
if [ "$S"x = "x" ]; then
	echo "Syntax: $0 <schemafile>"
	exit 1
fi

mysqldump -d -uroot -p \
	nwserver $S > $S.sql
