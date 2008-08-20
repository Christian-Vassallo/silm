# inherits stuff

all: revupdate preprocess compile

NCC=nwnnsscomp
NCCFLAGS=-g -c -q -o
NSSVERIFYFLAGS=-g -o -q -t4

includes := 

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
	@set -e; (gcc -undef -Wall -fextended-identifiers -P -E -nostdinc -Iglobal -include stddef.h -I . -include _const.nh -x c -std=c99 $< |\
		gpp +z -C +n --nostdinc -Iglobal -I. -Iglobal --include "gpp.h" > `basename $< .n`.nss)

$(objects) : %.ncs : %.nss
	$(NCC) $(NCCFLAGS) $(NWNHOME) $<

.PHONY: tags
tags:
	@ctags --language-force=c --totals --fields=fksmnSzt  global/*.h *.{n,nh,h} $(NWNHOME)/original_resources/*.nss

clean:
	-rm *.nss *.ncs *.ndb


