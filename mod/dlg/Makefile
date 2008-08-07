objects := $(basename $(wildcard *.dlg.yml))

all: $(objects)

$(objects) : %.dlg : %.dlg.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
