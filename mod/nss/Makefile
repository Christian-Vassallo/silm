# inherits stuff

all:
	$(MAKE) Makefile.dep
	$(MAKE) compile

NCC=nwnnsscomp
NCCFLAGS=-g -c -q -o
NSSVERIFYFLAGS=-g -o -q -t4

commit := $(shell git-rev-parse --short --verify HEAD)
fullcommit := $(shell git log --decorate -n 1|head -1|cut -d' ' -f2-)
commitdate := $(shell git log --decorate -n 1|grep Date|cut -f4- -d' ')
builddate := $(shell date "+%Y-%m-%d %X %z (%a, %d %b %Y)")

include Makefile.dep

globals := $(wildcard global/*.h)
scripts := $(wildcard *.n)
objects := $(addsuffix .ncs, $(basename $(objects)))
preprocessed := $(addsuffix .nss, $(basename $(scripts)))

.PHONY: Makefile.dep
Makefile.dep:
	@./build_dep_list.rb $(scripts) > Makefile.dep

revupdate:
	@echo '#define GIT_COMMIT_ON "$(commitdate)"' > git.h
	@echo '#define GIT_BUILD_ON "$(builddate)"'  >> git.h
	@echo '#define GIT_COMMIT "$(commit)"'       >> git.h

%.nss : %.n
	@set -e; (gcc -undef -Wall -fextended-identifiers -P -E -nostdinc -Iglobal -include stddef.h -I . -include _const.nh -x c -std=c99 $< |\
		gpp +z -C +n --nostdinc -Iglobal -I. -Iglobal --include "gpp.h" > `basename $< .n`.nss)

%.ncs : %.nss
	$(NCC) $(NCCFLAGS) $(NWNHOME) $<

compile: $(preprocessed) $(objects)

.PHONY: tags
tags:
	@ctags --language-force=c --totals --c-kinds=cdefgmnpstuvx --fields=fksmnSzt global/*.h *.{n,nh,h} $(NWNHOME)/original_resources/*.nss

clean:
	-rm *.nss *.ncs *.ndb
