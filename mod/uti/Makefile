include ../Makefile.resource

all: $(res) ../itp/itempalcus.itp

../itp/itempalcus.itp: ../mkpal $(res)
	../mkpal baseitems BaseItem UTI *.uti.yml > ../itp/itempalcus.itp
