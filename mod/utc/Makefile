objects := $(basename $(wildcard *.utc.yml))

all: $(objects)

$(objects) : %.utc : %.utc.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
