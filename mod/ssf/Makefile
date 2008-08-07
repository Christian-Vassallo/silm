objects := $(basename $(wildcard *.ssf.yml))

all: $(objects)

$(objects) : %.ssf : %.ssf.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
