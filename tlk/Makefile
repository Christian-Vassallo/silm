targets := $(basename $(wildcard *.tlk.source))

all: $(targets)

clean:
	-rm *.tlk

%.tlk : %.tlk.source
	PERLLIB=../build/lib ../build/tlkencode.pl -o $@ $<
