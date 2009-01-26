# Set as environment var!
# NWNHOME=/home/elven/nwn

TARGET=silm_2da.hak

VALIDEXT=*.2da *.itp

twoda := $(addsuffix .2da, $(basename $(wildcard *.2ds)))

all: $(TARGET)

path:
ifeq  "$(NWNHOME)" ""
	@echo "env var NWNHOME not set."
	exit 1
endif

# 2ds were generated with:
# for x in *.2da; do \
#   cat $x | ruby -ne 'print $_.gsub(/(\s)(\d+)(\s+)/) {|y| x = $2.to_i;  $1 + (x > 0xfffff0 ? "$(" + (x - 0xffffff - 1).to_s + ")" : $2) + $3 }' \
#   >! $(basename $x .2da).2ds; \
# done

%.2da : %.2ds
	@echo "$< -> $@"
	@cat $< | ruby -ne 'print $$_.gsub(/\$$\(([\d]+)\)/) {|x| $$1.to_i + 1 + 0xffffff}' > $@

clean-backup:
	-rm *.*~ *.out

clean: clean-backup
	rm *.2da
	
$(TARGET): $(twoda)
	erfpack.pl -H -o $@ $(VALIDEXT)

install: path
	@cp -v $(TARGET) $(NWNHOME)/hak/

publish:
	rsync -Pzva --chmod=go+r $(TARGET) elven@miyeritar.swordcoast.net::nwn-w/hak/
