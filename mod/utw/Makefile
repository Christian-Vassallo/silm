objects := $(basename $(wildcard *.utw.yml))

all: $(objects)

$(objects) : %.utw : %.utw.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
