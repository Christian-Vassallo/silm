# inherits stuff

NSS=../../buildutil/nwnnsscomp
NSSFLAGS=-g -o -q -c
NSSVERIFYFLAGS=-g -o -q -t4

all: scripts
compile: scripts
scripts:
	../../buildutil/update-revision.sh ..
	$(NSS) $(NSSFLAGS) $(NWNHOME) *.nss

verify:
	$(NSS) $(NSSVERIFYFLAGS) $(NWNHOME) *.nss

clean:
	-rm *.ncs *.ndb _buildinfo.nss

clean-backup:
	-rm *.*~ *.out

uncrustify:
	uncrustify -L 2 -c ../conf/uncrustify.cfg --replace -l C *.nss

