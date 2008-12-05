all: compile

clean:
	-rm *.nss *.ncs *.ndb Makefile.dep

clean-stale:
	@for x in *.n[cs]s; do [ -f `echo $$x |cut -d. -f1`.n ] || rm -v $$x; done

NCC=nwnnsscomp
NCCFLAGS=-g -c -q -o
NSSVERIFYFLAGS=-g -o -q -t4

# Various git/shell-related variables.
commit := $(shell git rev-parse --short --verify HEAD)
fullcommit := $(shell git log --decorate -n 1|head -1|cut -d' ' -f2-)
commitdate := $(shell git log --decorate -n 1|grep Date|cut -f4- -d' ')
builddate := $(shell date "+%Y-%m-%d %X %z (%a, %d %b %Y)")

corefiles := $(wildcard $(NWNHOME)/original_resources/*.nss)

headers := $(wildcard *.h *.nh)
scripts := $(wildcard *.n)
preprocessed := $(addsuffix .nss, $(basename $(scripts)))

# $(corefiles) all .nss files that are provided by NWN itself

# $(headers)   array of header files (.nh, .h) with extension
# $(scripts)   array of all script files (.n) with extension
# $(preprocessed) array of ALL script files that were preprocessed

include Makefile.dep

# From Makefile.dep:
# $(objects)   array of script basenames (without extension) that are compileable

Makefile.dep: $(headers) $(scripts)
	@echo "Building dependencies: Makefile.dep .."
	@./build_dep_list.rb -g stddef.h -g _const.nh $(headers) $(scripts) > Makefile.dep

revupdate:
	@echo '#define GIT_COMMIT_ON "$(commitdate)"' > git.h
	@echo '#define GIT_BUILD_ON "$(builddate)"'  >> git.h
	@echo '#define GIT_COMMIT "$(commit)"'       >> git.h

%.nss:
	@set -e; (gcc -undef -Wall -fextended-identifiers -P -E -nostdinc -include stddef.h -I . -include _const.nh -x c -std=c99 $< |\
		gpp +z -C +n --nostdinc -Iglobal -I. --include "gpp.h" > `basename $< .n`.nss)

%.ncs:
	$(NCC) $(NCCFLAGS) $(NWNHOME) $<

compile: Makefile.dep $(preprocessed) $(objects)

tags: $(headers) $(scripts) $(corefiles)
	@ctags --language-force=c --totals --c-kinds=cdefgmnpstuvx --fields=fksmnSzt $(headers) $(scripts) $(corefiles)
