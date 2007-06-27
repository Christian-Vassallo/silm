# Set as environment var!
# NWNHOME=/home/elven/nwn

NAME=silm_cloaks

VALIDEXT=*.plt

all: hak

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif


clean-backup:
	-rm *.*~ *.out

clean: clean-backup
	
hak: path
	erfpack.pl -H -o $(NWNHOME)/hak/$(NAME).hak $(VALIDEXT)

publish:
	rsync -Pzva $(NWNHOME)/hak/$(NAME).hak elven@miyeritar.swordcoast.net::nwn-w/hak/
