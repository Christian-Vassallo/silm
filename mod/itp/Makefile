UPITP=java -cp ../../buildutil/jnwserver net.swordcoast.jnwserver.util.UpdateITP

NAME=silm_itp

VALIDEXT=*palcus.itp

LIST=uti 

all: itp verify

creature:
	$(UPITP) ../utc creaturepalcus.itp
door:
	$(UPITP) ../utd doorpalcus.itp
encounter:
	$(UPITP) ../ute encounterpalcus.itp
item:
	$(UPITP) ../uti itempalcus.itp
placeable:
	$(UPITP) ../utp placeablepalcus.itp
sound:
	$(UPITP) ../uts soundpalcus.itp
store:
	$(UPITP) ../utm storepalcus.itp
trigger:
	$(UPITP) ../utt triggerpalcus.itp
waypoint:
	$(UPITP) ../utw waypointpalcus.itp


itp: creature door encounter item placeable sound store trigger waypoint

hak:
	erfpack.pl -H -o $(NWNHOME)/hak/$(NAME).hak $(VALIDEXT)

publish:
	rsync -Pzva $(NWNHOME)/hak/$(NAME).hak elven@swordcoast.net::nwn-w/hak/
