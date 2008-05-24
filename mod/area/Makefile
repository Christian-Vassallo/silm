all:


tiles:
	tile-extractor.pl -v -n $(NWNHOME) *.are

verify:
	for i in $(PFX)*.are $(PFX)*.git $(PFX)*.gic; do \
		echo $${i}; \
		gffprint.pl $${i} >/dev/null ; \
	done
