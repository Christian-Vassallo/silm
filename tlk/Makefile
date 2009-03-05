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
	tlkencode.pl -o $@ $<

install: $(targets)
	@cp -v $(targets) $(NWNHOME)/tlk/

publish: $(targets)
	rsync -Pzva --chmod=go+r $(targets) silbermarken@miyeritar:rsync/nwn/tlk/
