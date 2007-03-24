# Set as environment var!
# NWNHOME=/home/elven/nwn

NAMES=client_2da client_cep2c

VALIDEXT=*.2da *.itp

all: haks

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif


haks: path
	for i in $(NAMES); do \
		$(MAKE) -C $$i hak; done

publish: path
	for i in $(NAMES); do \
		$(MAKE) -C $$i publish; done
