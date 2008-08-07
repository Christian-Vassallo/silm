objects := $(basename $(wildcard *.ute.yml))

all: $(objects)

$(objects) : %.ute : %.ute.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
