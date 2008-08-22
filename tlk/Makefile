# Set as environment var!
# NWNHOME=/home/elven/nwn

targets := $(basename $(wildcard *.tlk.source))

all: path $(targets)

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif


clean:
	-rm *.tlk

%.tlk : %.tlk.source
	tlkencode.pl -o $(NWNHOME)/tlk/$@ $<

publish:
	for x in $(targets); do \
		rsync -Pzva --chmod=go+r $(NWNHOME)/tlk/$$x elven@miyeritar.swordcoast.net::nwn-w/tlk/ ; \
	done
