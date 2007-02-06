#include "inc_mysql"
#include "_gen"
#include "inc_cdb"
// Databased placplacs

const string
PLAC_TABLE = "placeables";

const int
SAVE_ERROR = 0,
SAVE_NEW = 1,
SAVE_UPDATE = 2;

void LoadPlaciesForArea(object oA);

int SavePlacie(object oP, object oPlacedBy = OBJECT_INVALID);

void SavePlaciesForArea(object oA);

void KillPlacies(object oA);

void KillPlacie(object oP, float fDelay = 0.0, int bDestroy = TRUE);

// Returns the placeable ID of this placie, or 0 if its not in database.
int GetPlaceableID(object oP);

// impl

void LoadPlaciesForArea(object oA) {
	if ( GetLocalInt(oA, "placies_loaded") )
		return;


	string sAreaTag = SQLEscape(GetResRef(oA));

	WriteTimestampedLogEntry("Loading Placies for " + sAreaTag);

	string sResRef, sName;
	vector v;
	float f;
	int id, nLocked;
	location lT;

	int count = 0;

	SQLQuery("select resref,x,y,z,f,`name`,`id`,`locked` from `" +
		PLAC_TABLE + "` where `area` = " + sAreaTag + ";");

	while ( SQL_SUCCESS == SQLFetch() ) {

		sResRef = SQLGetData(1);
		v.x = StringToFloat(SQLGetData(2));
		v.y = StringToFloat(SQLGetData(3));
		v.z = StringToFloat(SQLGetData(4));
		f = StringToFloat(SQLGetData(5));
		sName = SQLGetData(6);
		id = StringToInt(SQLGetData(7));
		nLocked = StringToInt(SQLGetData(8));

		lT = Location(oA, v, f);
		object oP = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lT, FALSE);
		if ( !GetIsObjectValid(oP) ) {
			SendMessageToAllDMs("Warning: Placeable creation failed for ResRef: " + sResRef);
			continue;
		}
		count += 1;

		if ( sName != "" )
			SetName(oP, sName);

		SetLocked(oP, nLocked == 1);

		SetLocalInt(oP, "placie_id", id);
	}

	WriteTimestampedLogEntry("Done loading: " + IntToString(count));

	SetLocalInt(oA, "placies_loaded", 1);
}



void SavePlaciesForArea(object oA) {
	string sAreaTag = SQLEscape(GetResRef(oA));

	string sResRef;
	vector v;
	float f;
	location lT;

	object oP = GetFirstObjectInArea(oA);

	while ( GetIsObjectValid(oP) ) {
		if ( GetIsPlaceable(oP) ) {
			if ( GetLocalInt(oP, "placie_id") > 0 ) {
				SavePlacie(oP);
			}

		}
		oP = GetNextObjectInArea(oP);
	}
}

void KillPlacies(object oA) {
	string sAreaTag = GetResRef(oA);
	if ( sAreaTag == "" )
		return;

	sAreaTag = SQLEscape(sAreaTag);

	SQLQuery("delete from `" + PLAC_TABLE + "` where `area` = " + sAreaTag + ";");
}


int SavePlacie(object oP, object oPlacedBy = OBJECT_INVALID) {
	if ( !GetIsPlaceable(oP) )
		return SAVE_ERROR;

	string sAreaTag = GetResRef(GetArea(oP));

	if ( sAreaTag == "" )
		return SAVE_ERROR;

	sAreaTag = SQLEscape(sAreaTag);

	int nID = 0;
	if ( GetIsPC(oPlacedBy) && !GetIsDM(oPlacedBy) )
		nID = GetCharacterID(oPlacedBy);

	int id = GetLocalInt(oP, "placie_id");
	vector v = GetPosition(oP);
	float f = GetFacing(oP);
	string sName = SQLEscape(GetName(oP));
	string sStoreTag = SQLEscape(GetLocalString(oP, "store_tag"));
	string sLockKey = SQLEscape(GetLockKeyTag(oP));

	if ( id == 0 ) {
		SQLQuery("insert into `" +
			PLAC_TABLE +
			"` (`area`,`name`,`store_tag`,`lock_key`,`resref`,`x`,`y`,`z`,`f`,`locked`,`first_placed_by`) values("
			+
			"" + sAreaTag + ", " +
			"" + sName + ", " +
			"" + sStoreTag + ", " +
			"" + sLockKey + ", " +
			"" + SQLEscape(GetResRef(oP)) + ", " +
			"" + FloatToString(v.x) + ", " + FloatToString(v.y) + ", " + FloatToString(v.z) + ", " +
			"'" + FloatToString(f) + "', " +
			"" + IntToString(GetLocked(oP)) + ", " + IntToString(nID) + "" +
			")");

		SQLQuery("select `id` from `" + PLAC_TABLE + "` order by `id` desc limit 1;");
		SQLFetch();
		id = StringToInt(SQLGetData(1));
		SetLocalInt(oP, "placie_id", id);
		return SAVE_NEW;

	} else {
		string sQ = "update `" + PLAC_TABLE + "` set " +
					"`resref` = " + SQLEscape(GetResRef(oP)) + ", " +
					"`x`='" +
					FloatToString(v.x) +
					"', `y`='" + FloatToString(v.y) + "', `z`='" + FloatToString(v.z) + "', " +
					"`f`='" + FloatToString(f) + "', " +
					"`area`=" + sAreaTag + ", " +
					"`name`=" + sName + ", " +
					"`store_tag`=" + sStoreTag + ", " +
					"`lock_key`=" + sLockKey + ", " +
					"`last_placed_by`=" + IntToString(nID) + " " +

					" where `id` = '" + IntToString(id) + "' limit 1;";

		SQLQuery(sQ);

		return SAVE_UPDATE;
	}
}

void KillPlacie(object oP, float fDelay = 0.0, int bDestroy = TRUE) {
	int id = GetLocalInt(oP, "placie_id");
	if ( id > 0 ) {
		SQLQuery("delete from `" + PLAC_TABLE + "` where `id` = '" + IntToString(id) + "' limit 1;");
	}
	if ( bDestroy )
		DestroyObject(oP, fDelay);
	else
		SetLocalInt(oP, "placie_id", 0);
}

int GetPlaceableID(object oP) {
	return GetLocalInt(oP, "placie_id");
}
