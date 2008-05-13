# Set as environment var!
# NWNHOME=/home/elven/nwn
LISTHOME=$(HOME)
NAME=www.silbermarken.de
BRANCH=$(shell git branch 2>&1| grep "*" | cut -d " " -f 2)

AREAS=$(shell ls area/*.git area/*.are area/*.gic | grep -v ooc_solace)

# This gets packaged into your final module
VALIDEXT=area/\*.git area/\*.are \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	`find uti -iname *.uti` \
 	nss/\*.ncs $(STERNENFALL)/mod/nss/\*.ncs

VALIDEXTDEV=$(AREAS) \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	`find uti -iname *.uti` \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	nss/\*.ncs nss/\*.nss


VALIDEXTBUILDER=$(AREAS) \
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


commit := $(shell git-rev-parse --short --verify HEAD)

# the holy grail
all: package dev-local player-local builder-local

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
	$(MAKE) -C nss clean 
	-rm *.mod

# remove older packages
clean-local:
	-rm $(NAME)-$(BRANCH)-{dev,builder,player}-r*.tgz

local: path
	erfpack.pl -m -o $(NAME)-$(BRANCH).mod $(VALIDEXT)

dev-local: path
	erfpack.pl -m -o $(NAME)-$(BRANCH)-dev-r$(commit).mod $(VALIDEXTDEV)
	tar -czf $(NAME)-$(BRANCH)-dev-r$(commit).tgz $(NAME)-$(BRANCH)-dev-r$(commit).mod && \
		rm $(NAME)-dev-r$(commit).mod

player-local: path
	erfpack.pl -m -o $(NAME)-$(BRANCH)-player-r$(commit).mod $(VALIDEXTPLAYER)
	tar -czf $(NAME)-$(BRANCH)-player-r$(commit).tgz $(NAME)-$(BRANCH)-player-r$(commit).mod && \
		rm $(NAME)-$(BRANCH)-player-r$(commit).mod

builder-local: path
	erfpack.pl -m -o $(NAME)-$(BRANCH)-builder-r$(commit).mod $(VALIDEXTBUILDER)
	tar -czf $(NAME)-$(BRANCH)-builder-r$(commit).tgz $(NAME)-$(BRANCH)-builder-r$(commit).mod && \
		rm $(NAME)-$(BRANCH)-builder-r$(commit).mod


# generates a new package with the current commit
package: path uti utp utc ifo itp scripts local
dev-package: path uti utp utc ifo itp dev-local
player-package: path uti utp utc ifo itp player-local
builder-package: path uti utp utc ifo itp builder-local

documentation:
	naturaldocs -o html ../doc -i nss -p naturaldocs-project

# installs all packaged in the relevant directories
install: 
	cp -v $(NAME)-$(BRANCH).mod $(NWNHOME)/modules/


