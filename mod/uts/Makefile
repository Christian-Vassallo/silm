objects := $(basename $(wildcard *.uts.yml))

all: $(objects)

$(objects) : %.uts : %.uts.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
