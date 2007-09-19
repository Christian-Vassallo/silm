#include "inc_mysql"
#include "_gen"
#include "inc_cdb"
// Persistant placeables

const string
TABLE = "persistent_objects";

const int
SAVE_ERROR = 0,
SAVE_NEW = 1,
SAVE_UPDATE = 2;

// Load all persistent objects for oA
// usually called by oncliententer
void LoadPersistentObjectsForArea(object oA);

// makes an existing object persistent, saving its properties to database
// and (optionally) adding a oPlayerPlacedBy if its a placeable
// Return: one of SAVE_*
int SetObjectPersistent(object oPC, object oPlayerPlacedBy = OBJECT_INVALID);

// Removes persistent object oA from the database, and
// destroys it (optionally)
void DestroyPersistentObject(object oP, float fDelay = 0.0, int bDestroy = TRUE);

// Returns the Object ID of the persistent Object, or 0 if its not.
int GetPersistentObjectID(object oP);

// impl

void LoadPersistentObjectsForArea(object oA) {
	if ( GetLocalInt(oA, "pobj_loaded") )
		return;
	string sAreaTag = SQLEscape(GetResRef(oA));
	WriteTimestampedLogEntry("Loading objects for " + sAreaTag);

	int nType;
	string sResRef, sName, sTag;
	vector v;
	float f;
	int id, nLocked;
	location lT;

	int count = 0;

	SQLQuery("select type,resref,tag,x,y,z,f,`name`,`id`,`locked` from `" +
		TABLE + "` where `area` = " + sAreaTag + ";");

	while ( SQL_SUCCESS == SQLFetch() ) {
		nType = StringToInt(SQLGetData(1));
		sResRef = SQLGetData(2);
		sTag = SQLGetData(3);
		v.x = StringToFloat(SQLGetData(4));
		v.y = StringToFloat(SQLGetData(5));
		v.z = StringToFloat(SQLGetData(6));
		f = StringToFloat(SQLGetData(7));
		sName = SQLGetData(8);
		id = StringToInt(SQLGetData(9));
		nLocked = StringToInt(SQLGetData(10));

		lT = Location(oA, v, f);
		object oP = CreateObject(nType, sResRef, lT, FALSE, sTag);
		if ( !GetIsObjectValid(oP) ) {
			SendMessageToAllDMs("Warning: Object creation failed for ID " + SQLGetData(8));
			continue;
		}
		count += 1;

		if ( sName != "" )
			SetName(oP, sName);

		SetLocked(oP, nLocked == 1);

		SetLocalInt(oP, "pobj_id", id);
	}

	WriteTimestampedLogEntry("Done loading: " + IntToString(count));

	SetLocalInt(oA, "pobj_loaded", 1);
}



int SetPersistentObjectPersistent(object oP, object oPlayerPlacedBy = OBJECT_INVALID) {
	if (!GetIsObjectValid(oP))
		return;

	// Saveable types:
	// Placeable
	// Waypoint
	if (
		!GetIsPlaceable(oP) &&
		!GetIsWaypoint(oP)
	)
		return SAVE_ERROR;

	string sAreaTag = GetResRef(GetArea(oP));

	if ( sAreaTag == "" )
		return SAVE_ERROR;

	sAreaTag = SQLEscape(sAreaTag);

	int nID = 0;
	if ( GetIsPC(oPlayerPlacedBy) && !GetIsDM(oPlayerPlacedBy) )
		nID = GetCharacterID(oPlayerPlacedBy);

	int id = GetLocalInt(oP, "pobj_id");
	int nType = GetObjectType(oP);
	vector v = GetPosition(oP);
	float f = GetFacing(oP);
	string sName = SQLEscape(GetName(oP));
	string sTag = SQLEscape(GetTag(oP));
	string sStoreTag = SQLEscape(GetLocalString(oP, "store_tag"));
	string sLockKey = SQLEscape(GetLockKeyTag(oP));

	if ( id == 0 ) {
		SQLQuery("insert into `" +
			TABLE +
			"` (`type`,`area`,`name`,`tag`,`store_tag`,`lock_key`,`resref`,`x`,`y`,`z`,`f`,`locked`,`first_placed_by`) values("
			+
			"" + IntToString(nType) + ", " +
			"" + sAreaTag + ", " +
			"" + sName + ", " +
			"" + sTag + ", " +
			"" + sStoreTag + ", " +
			"" + sLockKey + ", " +
			"" + SQLEscape(GetResRef(oP)) + ", " +
			"" + FloatToString(v.x) + ", " + FloatToString(v.y) + ", " + FloatToString(v.z) + ", " +
			"'" + FloatToString(f) + "', " +
			"" + IntToString(GetLocked(oP)) + ", " + IntToString(nID) + "" +
			")");

		SQLQuery("select `id` from `" + TABLE + "` order by `id` desc limit 1;");
		SQLFetch();
		id = StringToInt(SQLGetData(1));
		SetLocalInt(oP, "pobj_id", id);
		return SAVE_NEW;

	} else {
		string sQ = "update `" + TABLE + "` set " +
					"`resref` = " + SQLEscape(GetResRef(oP)) + ", " +
					"`x`='" +
					FloatToString(v.x) +
					"', `y`='" + FloatToString(v.y) + "', `z`='" + FloatToString(v.z) + "', " +
					"`f`='" + FloatToString(f) + "', " +
					"`area`=" + sAreaTag + ", " +
					"`name`=" + sName + ", " +
					"`tag`=" + sTag + ", " +
					"`store_tag`=" + sStoreTag + ", " +
					"`lock_key`=" + sLockKey + ", " +
					"`last_placed_by`=" + IntToString(nID) + " " +

					" where `id` = '" + IntToString(id) + "' limit 1;";

		SQLQuery(sQ);

		return SAVE_UPDATE;
	}
}

void DestroyPersistentObject(object oP, float fDelay = 0.0, int bDestroy = TRUE) {
	int id = GetLocalInt(oP, "pobj_id");
	if ( id > 0 ) {
		SQLQuery("delete from `" + TABLE + "` where `id` = '" + IntToString(id) + "' limit 1;");
	}
	if ( bDestroy )
		DestroyObject(oP, fDelay);
	else
		SetLocalInt(oP, "pobj_id", 0);
}

int GetPersistentObjectID(object oP) {
	return GetLocalInt(oP, "pobj_id");
}
