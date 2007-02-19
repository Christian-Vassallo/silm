# Set as environment var!
# NWNHOME=/home/elven/nwn
LISTHOME=$(HOME)
NAME=Silbermarken

# This gets packaged into your final module
VALIDEXT=area/\*.git area/\*.gic area/\*.are \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute uti/\*.uti \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	nss/\*.ncs nss/\*.nss

LISTS=uti utp utc utm


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
	$(MAKE) -C nss

verify: path
	$(MAKE) -C nss verify

lists: path
	for i in $(LISTS); do ../buildutil/gen_resref.rb $${i}.marshal $${i}/*.$${i} && \
		../buildutil/process_resref.rb $${i}.marshal $${i}.marshal.txt; \
	done

install-lists:
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
	$(MAKE) -C itp

uncrustify:
	$(MAKE) -C nss uncrustify

clean:
	$(MAKE) -C nss clean clean-backup
	rm *.mod
	
local: path
	../buildutil/erfpack.pl -m -o $(NAME).mod $(VALIDEXT)

install: 
	cp -v $(NAME).mod $(NWNHOME)/modules/

# generates a new package with the current revision
package: path scripts ifo itp local

all: clean package install
