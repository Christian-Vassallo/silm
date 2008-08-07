objects := $(basename $(wildcard *.utt.yml))

all: $(objects)

$(objects) : %.utt : %.utt.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
