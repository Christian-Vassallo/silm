# Set as environment var!
# NWNHOME=/home/elven/nwn

TARGET=silm_2da.hak

VALIDEXT=*.2da *.itp

twoda := $(addsuffix .2da, $(basename $(wildcard *.2ds)))

all: $(twoda) $(TARGET)

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

tailmodel.2ds:: appearance.2ds
	cat tailmodel.2ds | ./generate_tailmodel.2ds.rb appearance.2ds > tailmodel_new &&\
		mv tailmodel_new tailmodel.2ds

%.2da : %.2ds
	@echo "$< -> $@"
	@cat $< | ruby -ne 'print $$_.gsub(/\$$\(([\d]+)\)/) {|x| $$1.to_i + 1 + 0xffffff}' > $@
	@if [[ "$@" == parts_*.2da ]]; then\
		make_partstable.sh 0.0 < $@ > chg_`echo $@ | cut -d_ -f2-` ;\
		echo "make_partstable.sh 0.0 < $@ > chg_`echo $@ | cut -d_ -f2-`";\
	fi

clean-backup:
	-rm *.*~ *.out

clean: clean-backup
	rm *.2da
	
$(TARGET): $(twoda)
	erfpack.pl -H -o $@ $(VALIDEXT)

install: path $(TARGET)
	@cp -v $(TARGET) $(NWNHOME)/hak/

publish: $(TARGET)
	rsync -Pzva --chmod=go+r $(TARGET) silbermarken@miyeritar:rsync/nwn/hak/
