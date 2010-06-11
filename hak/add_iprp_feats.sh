#!/bin/sh

ID=$1
COST=$2

if [ ! -z "$(egrep " ${ID}\s*$" iprp_feats.2da)" ]; then
	echo "Feat already present." >&2
	exit 1
fi

label=$(~/code/nwn/nwn-lib.git/bin/nwn-2da-print.rb -t feat.2da LABEL $ID)
name=$(~/code/nwn/nwn-lib.git/bin/nwn-2da-print.rb -t feat.2da FEAT $ID)

last_id=$(tail -1 iprp_feats.2da | cut -d' ' -f1)
next_id=$[$last_id+1]
echo "${next_id}  ${name}   ${label}  ${COST}  ${ID}"
