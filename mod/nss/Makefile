# inherits stuff

NCC=../../buildutil/nwnnsscomp
NCCFLAGS=-g -c -q -o
NSSVERIFYFLAGS=-g -o -q -t4

includes := _gen _buildinfo _const \
	c_chessinc c_array4 c_const \
	corpse_raise \
	dmfi_dmwcs_inc dmfi_dmw_inc \
	tms_inc_spawn \
	_memleakfix \
	nw_i0_generic x0_i0_behavior x0_i0_spells x0_i0_treasure x2_inc_spellhook

includesstart := $(filter inc_% %_inc_% %_i0_% funcs_% %inc, $(basename $(wildcard *.nss)))

includesncs := $(addsuffix .ncs, $(includes) $(includesstart))
includesnss := $(addsuffix .nss, $(includes) $(includesstart))
objects  := $(filter-out $(includesncs), $(addsuffix .ncs, $(basename $(wildcard *.nss))))
sources  := $(filter-out $(includesnss), $(wildcard *.nss))


revision := $(shell svn info --non-interactive svn://cormanthor.swordcoast.net/silm_srv/ | grep Revision | cut -d " " -f 2)
# date := $(shell echo "$(svninfo)" | grep 'Last Changed Date' | cut -d " " -f 4-)
# root := $(shell echo "$(svninfo)" | grep 'Repository Root' | cut -d " " -f 3-)

builddate := $(shell date "+%Y-%m-%d %X %z (%a, %d %b %Y)")

depgrep = $(shell grep -E '^\#include ".+"' $(1) | sed 's/^\#include \"//g' | sed 's/\"$$//g')

all: update-revision $(objects)

scripts: $(objects)


_buildutil.nss: update-revision

update-revision:
	@echo 'const string PROJECT = "Silbermarken";' > _buildinfo.nss
	@echo 'const string REVISION = "$(revision)";' >>_buildinfo.nss
	@echo 'const string REPOSITORY = "/";' >>_buildinfo.nss
	@echo 'const string COMMIT_ON = "unknown";' >>_buildinfo.nss
	@echo 'const string BUILD_ON = "$(builddate)";' >>_buildinfo.nss


$(sources) : $(includesnss)

$(objects) : %.ncs : %.nss 
	$(NCC) $(NCCFLAGS) $(NWNHOME) $<

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif

clean:
	-rm *.ncs *.ndb

clean-backup:
	-rm *.*~ *.out

uncrustify:
	uncrustify -L 2 -c ../conf/uncrustify.cfg --replace -l C *.nss

deploy:
	rsync -Pdu --include \*.ncs --delete-after --exclude \* . $(NWNHOME)/res
