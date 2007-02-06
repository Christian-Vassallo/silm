# inherits stuff

NSS=nwnnsscomp
NSSFLAGS=-g -o -q -c
NSSVERIFYFLAGS=-g -o -q -t4

all: scripts
scripts:
	../update-revision.sh ..
	$(NSS) $(NSSFLAGS) $(NWNHOME) *.nss

verify:
	$(NSS) $(NSSVERIFYFLAGS) $(NWNHOME) *.nss

clean:
	-rm *.ncs *.ndb

clean-backup:
	-rm *.*~ *.out

uncrustify:
	uncrustify -L 2 -c uncrustify.cfg --replace -l C *.nss

