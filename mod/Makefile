# Set as environment var!
# NWNHOME=/home/elven/nwn
LISTHOME=$(HOME)
NAME=www.silbermarken.de

# This gets packaged into your final module
VALIDEXT=area/\*.git area/\*.are \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	`find uti -iname *.uti` \
 	nss/\*.ncs 

VALIDEXTDEV=area/\*.git area/\*.gic area/\*.are \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	`find uti -iname *.uti` \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	nss/\*.ncs nss/\*.nss


VALIDEXTBUILDER=area/\*.git area/\*.gic area/\*.are \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	`find uti -iname *.uti` \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl 


# only include placeables, and an empty starting area
VALIDEXTPLAYER=utp/\*.utp \
	itp/placeablepalcus.itp \
	itp/doorpalcus.itp \
	itp/soundpalcus.itp \
	ssf/\*.ssf \
	mod/\*.fac mod/\*.jrl \
	override-player/\*

LISTS=uti utp utc utm


revision := $(shell svn info --non-interactive svn://cormanthor.swordcoast.net/silm_srv/ | grep Revision | cut -d " " -f 2)

all: package install

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif
ifeq  "$(LISTHOME)" ""
	@echo "env var LISTHOME not set."
	exit 1
endif

script: scripts
scripts: path
	$(MAKE) -j 2 -C nss

deploy:
	$(MAKE) -C nss deploy

clean-deploy:
	rm -rf $(NWNHOME)/res/*

lists: path
	for i in $(LISTS); do gen_resref.rb $${i}.marshal $${i}/*.$${i} && \
		process_resref.rb $${i}.marshal $${i}.marshal.txt; \
	done
	gen_resref.rb are.marshal area/*.are && \
		process_resref.rb are.marshal are.marshal.txt;

lists_install:
	for i in $(LISTS); do \
		cp -v $${i}.marshal $(LISTHOME) && \
		cp -v $${i}.marshal.txt $(LISTHOME); \
	done
	

unused-dlg:
	find-unused-conversations.pl -v dlg/*.dlg nss/*.nss area/*.git utc/*.utc

unused-nss:
	$(MAKE) -C nss unused

ifo:
	$(MAKE) -C mod ifo

itp:
	$(MAKE) -C itp all

uti:
	$(MAKE) -C uti recipes

utp:
	$(MAKE) -C utp all
utc:
	$(MAKE) -C utc all

uncrustify:
	$(MAKE) -C nss uncrustify

clean:
	$(MAKE) -C nss clean clean-backup
	-rm *.mod

# remove older packages
clean-local:
	rm $(NAME)-*-r[^$(revision)*.mod
	rm $(NAME)-*-r*.tgz

local: path
	erfpack.pl -m -o $(NAME).mod $(VALIDEXT)

dev-local: path
	erfpack.pl -m -o $(NAME)-dev-r$(revision).mod $(VALIDEXTDEV)

player-local: path
	erfpack.pl -m -o $(NAME)-player-r$(revision).mod $(VALIDEXTPLAYER)
	tar -czf $(NAME)-player-r$(revision).tgz $(NAME)-player-r$(revision).mod
	rm $(NAME)-player-r$(revision).mod

builder-local: path
	erfpack.pl -m -o $(NAME)-builder-r$(revision).mod $(VALIDEXTBUILDER)
	tar -czf $(NAME)-builder-r$(revision).tgz $(NAME)-builder-r$(revision).mod
	rm $(NAME)-builder-r$(revision).mod


install: 
	cp -v $(NAME).mod $(NWNHOME)/modules/

# generates a new package with the current revision
package: path uti utp utc ifo itp scripts local
dev-package: path uti utp utc ifo itp dev-local
player-package: path uti utp utc ifo itp player-local
builder-package: path uti utp utc ifo itp builder-local
