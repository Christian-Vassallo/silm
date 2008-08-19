objects := $(basename $(wildcard *.yml))

all:  $(objects) ifo

ifo:
	update-ifo.pl ../area/\*.are

$(objects) : % : %.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm -v $(objects)
