include ../Makefile.resource

.PHONY: module.ifo
module.ifo: module.ifo.yml
	nwn-gff $(EXPORT_FILTERS) -ly -i $< -kg -o $@
	update-ifo.pl ../area/\*.are
