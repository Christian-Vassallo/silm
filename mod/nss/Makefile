# inherits stuff

all: preprocess-sternenfall revupdate preprocess compile


preprocess-sternenfall:
	make -C $(STERNENFALL)/mod/nss/ preprocess

NCC=nwnnsscomp
NCCFLAGS=-g -c -q -o -i $(STERNENFALL)/mod/nss
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

commit := $(shell git-rev-parse --short --verify HEAD)
fullcommit := $(shell git log --decorate -n 1|head -1|cut -d' ' -f2-)
commitdate := $(shell git log --decorate -n 1|grep Date|cut -f4- -d' ')
builddate := $(shell date "+%Y-%m-%d %X %z (%a, %d %b %Y)")

revupdate:
	@echo '#define GIT_COMMIT_ON "$(commitdate)"' > git.h
	@echo '#define GIT_BUILD_ON "$(builddate)"'  >> git.h
	@echo '#define GIT_COMMIT "$(commit)"'       >> git.h


preprocess: $(preprocessed)
compile: $(objects)

$(preprocessed) : %.nss : %.n
	@set -e; (gcc -undef -Wall -fextended-identifiers -P -E -nostdinc -I$(STERNENFALL)/mod/nss -I$(STERNENFALL)/mod/nss/global -include stddef.h -I . -x c -std=c99 $< |\
		gpp +z -C +n --nostdinc -I$(STERNENFALL)/mod/nss -I$(STERNENFALL)/mod/nss/global -I. -Iglobal --include "gpp.h" > `basename $< .n`.nss)

$(objects) : %.ncs : %.nss
	$(NCC) $(NCCFLAGS) $(NWNHOME) $<


etags:
	@ctags --language-force=c --totals --fields=fksmnSzt  global/*.h *.{n,nh,h} $(NWNHOME)/original_resources/nss/*.nss $(STERNENFALL)/mod/nss/* $(STERNENFALL)/mod/nss/global/*

clean:
	-rm *.nss *.ncs *.ndb


