# This Makefile depends on some of NWNs resource files.
# In order to compile anything, you need NWN installed,
# and set this environment variable to the path. You can
# do this outside of make by exporting it in your shell
# environment. Example:
# export NWNHOME=/home/elven/nwn

# Also, to build anything useful, this Makefile depends on
# the path 'build' in this repository to be accessible
# through $PATH, $PERLLIB and $CLASSPATH.

# Settings below:

# The name of the module that is being built.
# Set this in your env.
# NWNMODNAME=www.sternenfall.org

# The current working branch in git.
BRANCH=$(shell git branch 2>&1| grep "*" | cut -d " " -f 2)

# The current commit hash.
COMMIT=$(shell git-rev-parse --short --verify HEAD)

ifeq "$(CONCURRENCY_LEVEL)" ""
CONCURRENCY_LEVEL=1
endif

# This gets packaged into your final module for
# deployment on a production server.
VALIDEXT= \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	`find uti -iname \*.uti` \
 	nss/\*.ncs

# This gets packaged into a developer package, which has
# ALL content.
VALIDEXTDEV=area/\*.git area/\*.are \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	`find uti -iname \*.uti` \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl

# The player package is a leightweight module variant for
# players to build their own areas, items, etc.
VALIDEXTPLAYER=utp/\*.utp \
	itp/placeablepalcus.itp \
	itp/doorpalcus.itp \
	itp/soundpalcus.itp \
	ssf/\*.ssf \
	mod/\*.fac mod/\*.jrl \
	override-player/\*

RESOURCEDIRS=area dlg ssf utc utd ute uti utm utp uts utt utw mod itp

NWNLIB_VERSION=0.4.4

# End of settings.
# Now type "make all" and hope for the best. :)

.PHONY: all path
all: package

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif
ifeq "$(NWNMODNAME)" ""
	@echo "env var NWNMODNAME not set."
	exit 1
endif
	@ruby -rubygems -e "gem 'nwn-lib', '>= $(NWNLIB_VERSION)'" || (\
		echo "Your nwn-lib version is too old. Upgrade at least to $(NWNLIB_VERSION)."; exit 1)

.PHONY: mandatory-verify
mandatory-verify:
	@echo Verifying resources ..
	@./verify-resources.sh

.PHONY: resources
resources: path mandatory-verify
	@for res in $(RESOURCEDIRS); do \
		$(MAKE) -j$(CONCURRENCY_LEVEL) -C $$res all ;\
	done

.PHONY: refilter-resources
refilter-resources: path mandatory-verify
	@for res in $(RESOURCEDIRS); do \
		$(MAKE) -j$(CONCURRENCY_LEVEL) -C $$res run-filters-on-yml ;\
	done

.PHONY: scripts
scripts: path
	$(MAKE) -j$(CONCURRENCY_LEVEL) -C nss revupdate all

clean:
	@echo Do you really want to clean? This will incur significant rebuild time.
	@echo It is usually recommended to manually clean only the resources you want to rebuild.
	@echo Press Enter to continue, or Ctrl-C to abort.
	@read
	@for res in $(RESOURCEDIRS); do \
		$(MAKE) -C $$res clean ;\
	done
	-@rm *.mod

local: resources scripts
ifeq ($(MAPMASK),)
	@echo "Packing up all maps."
	erfpack.pl -m -o $(NWNMODNAME)-$(BRANCH).mod area/\*.are area/\*.git $(VALIDEXT)
else
	@echo "Packing up maps matching: $(MAPMASK)"
	erfpack.pl -m -o $(NWNMODNAME)-$(BRANCH).mod area/$(MAPMASK).are area/$(MAPMASK).git $(VALIDEXT)
endif
	erfpack.pl -m -o $(NWNMODNAME)-$(BRANCH)-dev.mod $(MAPS) $(VALIDEXTDEV)
	erfpack.pl -m -o $(NWNMODNAME)-$(BRANCH)-player.mod $(MAPS) $(VALIDEXTPLAYER)

tar: local
	tar -czf $(NWNMODNAME)-$(BRANCH).tgz $(NWNMODNAME)-$(BRANCH).mod
	tar -czf $(NWNMODNAME)-$(BRANCH)-dev.tgz $(NWNMODNAME)-$(BRANCH)-dev.mod
	tar -czf $(NWNMODNAME)-$(BRANCH)-player.tgz $(NWNMODNAME)-$(BRANCH)-player.mod

# generates a new package with the current commit
package: path local

# installs all packaged in the relevant directories
install:
	cp -v $(NWNMODNAME)-$(BRANCH).mod $(NWNMODNAME)-$(BRANCH)-dev.mod $(NWNMODNAME)-$(BRANCH)-player.mod $(NWNHOME)/modules/
