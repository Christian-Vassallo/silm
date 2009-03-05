# Set as environment var!
# NWNHOME=/home/elven/nwn

TARGET=silm_cep2c.hak

VALIDEXT=*.dds *.mdl *.plt *.ssf *.tga *.wav

resources := $(wildcard $(VALIDEXT))

all: $(TARGET)

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif

clean-backup:
	-rm *.*~ *.out

clean: clean-backup
	
$(TARGET): $(resources)
	erfpack.pl -H -o $@ $(VALIDEXT)

install: path $(TARGET)
	@cp -v $(TARGET) $(NWNHOME)/hak/

publish: $(TARGET)
	rsync -Pzva --chmod=go+r $(TARGET) silbermarken@miyeritar:rsync/nwn/hak/
