# The name of the module that is being built.
# Set this in your env.
# NWNMODNAME=www.sternenfall.org

# This gets packaged into your final module for
# deployment on a production server.
VALIDEXT= \
	dlg/\*.dlg utm/\*.utm utp/\*.utp uts/\*.uts utt/\*.utt utw/\*.utw \
	utc/\*.utc utd/\*.utd ute/\*.ute \
	itp/\*.itp ssf/\*.ssf \
	mod/\*.fac mod/\*.ifo mod/\*.jrl \
	`find uti -iname \*.uti` \
 	nss/\*.ncs

# The player package is a leightweight module variant for
# players to build their own areas, items, etc.
VALIDEXTPLAYER=utp/\*.utp \
	itp/placeablepalcus.itp \
	mod/\*.fac \
	override-player/\*.*

RESOURCEDIRS=area dlg ssf utc utd ute uti utm utp uts utt utw mod itp

NWNLIB_VERSION=0.4.6

# End of settings.
# Now type "make all" and hope for the best. :)

.PHONY: all path
all: path package

path:
ifeq "$(NWNMODNAME)" ""
NWNMODNAME="silbermarken"
endif
ifeq "$(CONCURRENCY_LEVEL)" ""
CONCURRENCY_LEVEL=$(cat /proc/cpuinfo | grep processor | wc -l)
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

.PHONY: show-stale
show-stale: path
	@for res in $(RESOURCEDIRS); do \
		$(MAKE) -C $$res show-stale ;\
	done

.PHONY: clean-stale
clean-stale: path
	@for res in $(RESOURCEDIRS); do \
		$(MAKE) -C $$res clean-stale ;\
	done


.PHONY: scripts
scripts: path
	-rm nss/git.h
	$(MAKE) -C nss revupdate
	$(MAKE) -j$(CONCURRENCY_LEVEL) -C nss all

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
	PERLLIB=../build/lib ../build/erfpack.pl \
		-m -o $(NWNMODNAME).mod area/\*.are area/\*.git $(VALIDEXT)
else
	@echo "Packing up maps matching: $(MAPMASK)"
	PERLLIB=../build/lib ../build/erfpack.pl \
		-m -o $(NWNMODNAME).mod area/$(MAPMASK).are area/$(MAPMASK).git $(VALIDEXT)
endif

local-player: resources
	cp mod/module.ifo override-player
	cd override-player && PERLLIB=../../build/lib ../../build/update-ifo.pl *.are
	PERLLIB=../build/lib ../build/erfpack.pl \
		-m -o $(NWNMODNAME)-player.mod $(MAPS) $(VALIDEXTPLAYER)

# generates a new package with the current commit
package: local

package-player: local-player
