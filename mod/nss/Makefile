NO_COLOR=\x1b[0m
OK_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m

all: Makefile.dep compile

clean:
	-rm *.nss *.ncs *.ndb Makefile.dep $(autogen)

NCC=../../build/nwnnsscomp
NCCFLAGS=-g -c -q -o

corefiles := $(wildcard ../../gamedata/override/*.nss)

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

autogen := appearance.h draconic.n

draconic.n: gen_language_file ../../hak/client_2da/spells.2ds
	make -C ../../hak/client_2da/ spells.2ds
	./gen_language_file > draconic.n

draconic.nss: draconic.n

appearance.h: generate_appearance_h
	./generate_appearance_h > appearance.h

Makefile.dep: $(autogen) $(headers) $(scripts)
	@echo "Building dependencies: Makefile.dep .."
	@./build_dep_list.rb -g stddef.h -g _const.nh $(headers) $(scripts) > Makefile.dep

%.nss:
	@set -e; (gcc -undef -Wall -P -E -nostdinc -include stddef.h -I . -include _const.nh -x c -std=c99 $< |\
		gpp +z -C +n --nostdinc -Iglobal -I. --include "gpp.h" > `basename $< .n`.nss) && \
		echo " $(OK_COLOR)[OK]$(NO_COLOR) gpp $<"

%.ncs:
	@$(NCC) $(NCCFLAGS) ../../gamedata $< && \
		echo " $(OK_COLOR)[OK]$(NO_COLOR) ncc $<"

compile: $(preprocessed) $(objects)

.tags: $(headers) $(scripts) $(corefiles)
	@ctags --language-force=c --totals --c-kinds=cdefgmnpstuvx --fields=fksmnSzt $(corefiles) $(scripts) $(headers) .tags

show-stale:
	@for x in *.n[cs]s; do [ -f `echo $$x |cut -d. -f1`.n ] || echo $$x; done
