are_objects := $(basename $(wildcard *.are.yml))
git_objects := $(basename $(wildcard *.git.yml))

all: $(are_objects) $(git_objects)

$(are_objects) : %.are : %.are.yml
	nwn-gff-import -y -o $@ $<
$(git_objects) : %.git : %.git.yml
	nwn-gff-import -y -o $@ $<

clean:
	-@rm $(are_objects) $(git_objects)

tiles:
	tile-extractor.pl -v -n $(NWNHOME) *.are

verify:
	for i in $(PFX)*.are $(PFX)*.git; do \
		echo $${i}; \
		gffprint.pl $${i} >/dev/null ; \
	done

