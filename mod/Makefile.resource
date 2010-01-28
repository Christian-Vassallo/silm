yml := $(wildcard *.yml)
res := $(basename $(yml))

IMPORT_FILTERS := $(shell ../nwn-lib-import-filters.sh)
EXPORT_FILTERS := $(shell ../nwn-lib-export-filters.sh)

all: $(res)

% : %.yml
	nwn-gff $(EXPORT_FILTERS) -ly -i $< -kg -o $@

run-filters-on-yml:
	@for x in $(res); do \
		echo nwn-gff $(IMPORT_FILTERS) -lg -i $$x -ky -o $$x.yml ; \
		nwn-gff $(IMPORT_FILTERS) -lg -i $$x -ky -o $$x.yml ; \
	done

clean:
	-@rm $(res)

show-stale:
	@for x in *.*; do \
		[[ $$x == *.yml ]] && continue; \
		[[ -f $$x.yml ]] || echo $$x; \
	done

clean-stale:
	@for x in *.*; do \
		[[ $$x == *.yml ]] && continue; \
		[[ -f $$x.yml ]] || rm $$x; \
	done
