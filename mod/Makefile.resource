yml := $(wildcard *.yml)
res := $(basename $(yml))

IMPORT_FILTERS := $(shell ../nwn-lib-import-filters.sh)
EXPORT_FILTERS := $(shell ../nwn-lib-export-filters.sh)

all: $(res)

% : %.yml
	nwn-gff $(EXPORT_FILTERS) -ly -i $< -kg -o $@

run-filters-on-yml:
	@for x in $(res); do \
		echo nwn-gff --encoding=windows-1252 $(IMPORT_FILTERS) -lg -i $$x -ky -o $$x.yml ; \
		nwn-gff --encoding=windows-1252 $(IMPORT_FILTERS) -lg -i $$x -ky -o $$x.yml ; \
	done

clean:
	-@rm $(res)

show-stale:
	@for x in *.*; do \
		case "$$x" in \
			*.yml) \
				;; \
			*) \
				if [ ! -f "$$x.yml" ]; then \
					echo "$$x"; \
				fi \
				;; \
		esac \
	done

clean-stale:
	@for x in *.*; do \
		case "$$x" in \
			*.yml) \
				;; \
			*) \
				if [ ! -f "$$x.yml" ]; then \
					echo "Removing stale: $$x"; \
					rm $$x; \
				fi \
				;; \
		esac \
	done
