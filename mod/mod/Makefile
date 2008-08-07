all:  resources ifo

ifo:
	update-ifo.pl ../area/\*.are

resources:
	nwn-gff-import -y -o module.ifo module.ifo.yml
	nwn-gff-import -y -o module.jrl module.jrl.yml
	nwn-gff-import -y -o repute.fac repute.fac.yml

clean:
	-@rm -v module.ifo module.jrl repute.fac
