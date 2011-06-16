targets := $(basename $(wildcard *.tlk.source))

all: $(targets)

clean:
	-rm *.tlk

%.tlk : %.tlk.source
	tlkencode.pl -o $@ $<
