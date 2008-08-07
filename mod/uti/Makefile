objects := $(basename $(wildcard *.uti.yml))

all: $(objects)

$(objects) : %.uti : %.uti.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
