include ../Makefile.resource

all: $(res) ../itp/creaturepalcus.itp

../itp/creaturepalcus.itp: $(res)
	../mkpal racialtypes Race UTC *.utc.yml > ../itp/creaturepalcus.itp
