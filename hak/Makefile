# Set as environment var!
# NWNHOME=/home/elven/nwn

HAKNAMES=client_2da client_cep2c

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif

all: hak hak-publich

hak: path
	for i in $(HAKNAMES); do \
		$(MAKE) -C $$i hak; done

hak-publish: path
	for i in $(HAKNAMES); do \
		$(MAKE) -C $$i publish; done
