#include "inc_pgsql"
#include "inc_cdb"

const string
	TABLE_LASTLOCATION = "last_location";

location GetLastLocationOnLogout(object oPC);
void SetLastLocation(object oPC);

location GetLastLocationOnLogout(object oPC) {
	int id = GetCharacterID(oPC);
	location ret;

/*	if (id) {
		pQ("select x,y,z,f,area from " + TABLE_LASTLOCATION + " where character = " + IntToString(id) + ";");
		if (pF()) {
			ret.position = Vector(pGf(1), pGf(2), pGf(3));
			ret.area = GetObjectByTag(pG(5));
			ret.facing = pGf(4);
		}
	}*/
	return ret;
}


void SetLastLocation(object oPC) {
	int id = GetCharacterID(oPC);
	if (!id)
		return;

/*	pQ("select id from " + TABLE_LASTLOCATION + " where character = " + IntToString(id) + ";");
	if (pF()) {

	} else {
		pQ("update " + TABLE_LASTLOCATION + " set " +
		"x = " + 
		"y = " +
		"z = " + 
		"f = " +
		"area = " +

		" where character = " + IntToString(id) + ";");
	}*/
}
