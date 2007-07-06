
verify:
	for i in $(PFX)*.utc; do \
		echo $${i}; \
		gffprint.pl $${i} >/dev/null ; \
	done


deploy:
	rsync -Pdu --include \*.utc --delete-after --exclude \* . $(NWNHOME)/res
