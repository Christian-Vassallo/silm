objects := $(basename $(wildcard *.utm.yml))

all: $(objects)

$(objects) : %.utm : %.utm.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
