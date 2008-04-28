# inherits stuff

all: clean preprocess-sternenfall preprocess compile inst

inst:
	cp -v *.ncs ~/nwserver/res/


preprocess-sternenfall:
	make -C $(STERNENFALL)/mod/nss/ preprocess

NCC=nwnnsscomp
NCCFLAGS=-g -c -q -o -i $(STERNENFALL)/mod/nss -i .. -i .
NSSVERIFYFLAGS=-g -o -q -t4

includes :=

includesstart := $(filter inc_% %_inc_% %_i0_% funcs_% %inc, $(basename $(wildcard *.nss)))

includesncs := $(addsuffix .ncs, $(includes) $(includesstart))
includesnss := $(addsuffix .nss, $(includes) $(includesstart))
sources  := $(filter-out $(includesnss), $(wildcard *.nss))

topreprocess := $(wildcard *.n)
preprocessed := $(addsuffix .nss, $(basename $(wildcard *.n)))

objects  := $(filter-out $(includesncs), $(addsuffix .ncs, $(basename $(wildcard *.n))))

preprocess: $(preprocessed)
compile: $(objects)

$(preprocessed) : %.nss : %.n
	@set -e; (gcc -undef -Wall -fextended-identifiers -P -E -nostdinc -I$(STERNENFALL)/mod/nss -I$(STERNENFALL)/mod/nss/global -include stddef.h -I . -I .. -x c -std=c99 $< |\
		gpp +z -C +n --nostdinc -I$(STERNENFALL)/mod/nss -I$(STERNENFALL)/mod/nss/global -I. -I.. -Iglobal --include "gpp.h" > `basename $< .n`.nss)

$(objects) : %.ncs : %.nss
	$(NCC) $(NCCFLAGS) $(NWNHOME) $<


etags:
	@ctags --language-force=c --totals --fields=fksmnSzt  global/*.h *.{n,nh,h} $(NWNHOME)/original_resources/nss/*.nss $(STERNENFALL)/mod/nss/* $(STERNENFALL)/mod/nss/global/*

clean:
	-rm *.nss *.ncs *.ndb
