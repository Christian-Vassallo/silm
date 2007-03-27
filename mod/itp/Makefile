UPITP=java -cp ../../buildutil/jnwserver net.swordcoast.jnwserver.util.UpdateITP
NAME=silm_itp

VALIDEXT=*palcus.itp
LIST=uti 

all: itp

itp:
	for i in $(LIST); do \
		$(UPITP) ../$$i $$i.palette; \
	done

verify:
	for i in $(PFX)*.itp; do \
		echo $${i}; \
		gffprint.pl $${i} >/dev/null ; \
	done

hak:
	erfpack.pl -H -o $(NWNHOME)/hak/$(NAME).hak $(VALIDEXT)

publish:
	rsync -Pzva $(NWNHOME)/hak/$(NAME).hak elven@swordcoast.net::nwn-w/hak/
