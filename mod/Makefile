# Set as environment var!
# NWNHOME=/home/elven/nwn
LISTHOME=$(HOME)
NAME=Silbermarken

# This gets packaged into your final module
VALIDEXT=area/\*.git area/\*.are \
	utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utd/\*.utd ute/\*.ute \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl 

VALIDEXTDEV=area/\*.git area/\*.are \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	`find uti -iname *.uti` \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	nss/\*.ncs nss/\*.nss

VALIDEXTPLAYER=area/\*.git area/\*.are \
	utp/\*.utp \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl 

LISTS=uti utp utc utm

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
	$(MAKE) -C uti deploy
	$(MAKE) -C utc deploy
	$(MAKE) -C dlg deploy

clean-deploy:
	rm -rf $(NWNHOME)/res/*

lists: path
	for i in $(LISTS); do ../buildutil/gen_resref.rb $${i}.marshal $${i}/*.$${i} && \
		../buildutil/process_resref.rb $${i}.marshal $${i}.marshal.txt; \
	done
	../buildutil/gen_resref.rb are.marshal area/*.are && \
		../buildutil/process_resref.rb are.marshal are.marshal.txt;

lists_install:
	for i in $(LISTS); do \
		cp -v $${i}.marshal $(LISTHOME) && \
		cp -v $${i}.marshal.txt $(LISTHOME); \
	done
	

unused-dlg:
	../buildutil/find-unused-conversations.pl -v dlg/*.dlg nss/*.nss area/*.git utc/*.utc

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


local: path
	../buildutil/erfpack.pl -m -o $(NAME).mod $(VALIDEXT)
dev-local: path
	../buildutil/erfpack.pl -m -o $(NAME).mod $(VALIDEXTDEV)
player-local: path
	../buildutil/erfpack.pl -m -o $(NAME).mod $(VALIDEXTPLAYER)

install: 
	cp -v $(NAME).mod $(NWNHOME)/modules/

# generates a new package with the current revision
package: path uti utp utc ifo itp scripts local
dev-package: path uti utp utc ifo itp dev-local
