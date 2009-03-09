yml := $(wildcard *.yml)
res := $(basename $(yml))

IMPORT_FILTERS := $(shell ../nwn-lib-import-filters.sh)
EXPORT_FILTERS := $(shell ../nwn-lib-export-filters.sh)

all: $(res)

% : %.yml
	nwn-gff $(EXPORT_FILTERS) -ly -i $< -kg -o $@

run-filters-on-yml:
	@for x in $(yml); do \
		echo nwn-gff $(IMPORT_FILTERS) -ly -i $$x -ky -o $$x ; \
		nwn-gff $(IMPORT_FILTERS) -ly -i $$x -ky -o $$x ; \
	done

clean:
	-@rm $(res)

show-stale:
	@for x in *.*; do \
		[[ $$x == *.yml ]] && continue; \
		[[ -f $$x.yml ]] || echo "stale file: $$x"; \
	done
