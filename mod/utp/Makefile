objects := $(basename $(wildcard *.utp.yml))

all: $(objects)

$(objects) : %.utp : %.utp.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(objects)
