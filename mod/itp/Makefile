all: warn itp

.PHONY: warn
warn:
	@echo "WARNING: palette generation not functional."

objects := $(basename $(wildcard *.itp.yml))

itp: $(objects)

$(objects) : %.itp : %.itp.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
