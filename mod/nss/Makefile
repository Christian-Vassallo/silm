# inherits stuff

all: revupdate preprocess compile


NCC=nwnnsscomp
NCCFLAGS=-g -c -q -o
NSSVERIFYFLAGS=-g -o -q -t4

includes := _gen _buildinfo _const \
	c_chessinc c_array4 c_const \
	corpse_raise \
	dmfi_dmwcs_inc dmfi_dmw_inc \
	tms_inc_spawn \
	_memleakfix \
	c_db time x0_i0_walkway \
	nw_i0_generic x0_i0_behavior x0_i0_spells x0_i0_treasure x2_inc_spellhook

includesstart := $(filter inc_% %_inc_% %_i0_% funcs_% %inc, $(basename $(wildcard *.nss)))

includesncs := $(addsuffix .ncs, $(includes) $(includesstart))
includesnss := $(addsuffix .nss, $(includes) $(includesstart))
sources  := $(filter-out $(includesnss), $(wildcard *.nss))

topreprocess := $(wildcard *.n)
preprocessed := $(addsuffix .nss, $(basename $(wildcard *.n)))

objects  := $(filter-out $(includesncs), $(addsuffix .ncs, $(basename $(wildcard *.n))))




# revision := $(shell svn info .. | grep Revision | cut -d " " -f 2)
# date := $(shell svn info .. | grep 'Last Changed Date' | cut -d " " -f 4-)
builddate := $(shell date "+%Y-%m-%d %X %z (%a, %d %b %Y)")

revupdate:
	@echo "#define SVN_REVISION 0"      > svn.h
# 	@echo '#define SVN_REVISION_S "$(revision)"' >> svn.h
	@echo '#define SVN_PROJECT "Silbermarken"'   >> svn.h
	@echo '#define SVN_REPOSITORY "/"'           >> svn.h
	@echo '#define SVN_COMMIT_ON "unknown"'      >> svn.h
	@echo '#define SVN_BUILD_ON "$(builddate)"'  >> svn.h


preprocess: $(preprocessed)
compile: $(objects)

$(preprocessed) : %.nss : %.n
	@set -e; (gcc -undef -Wall -fextended-identifiers -P -E -nostdinc -I. -Iglobal -include stddef.h -x c -std=c99 $< |\
		gpp +z -C +n --nostdinc -I. -Iglobal --include "gpp.h" > `basename $< .n`.nss)

$(objects) : %.ncs : %.nss
	$(NCC) $(NCCFLAGS) $(NWNHOME) $<




clean:
	-rm *.nss *.ncs *.ndb


