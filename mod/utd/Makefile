objects := $(basename $(wildcard *.utd.yml))

all: $(objects)

$(objects) : %.utd : %.utd.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
