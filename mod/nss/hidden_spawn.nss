#include "inc_hiddenspawn"
#include "_gen"


// Returns true if no player is within search distance
int HideSpawn();

int GetActiveSpawnsOfTypeInDistance(string sType, float fD);

int GetActiveSpawnsOfTypeInArea(string sType);

void main() {
	object oH = OBJECT_SELF;

	string sType = GetLocalString(oH, "type");

	if ( HideSpawn() )
		return;

	int nVisible = GetIsObjectValid(GetLocalObject(oH, "spawned_object"));
	if ( nVisible ) {
		//dbg("Spawn still active.");
		return;
	}

	// Timestamp spam
	return;

	int nDoSpawn = FALSE;

	int nTS = GetUnixTimestamp();

	object oPC;

	struct HiddenSpawn r;

	r = GetFirstHiddenSpawnForType(sType);

	while ( GetIsHiddenSpawnValid(r) ) {
		//dbg("ValidHS: " + HiddenSpawnToString(r));
		// Check the search distance
		oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
		if ( !GetIsPC(oPC) ) {
			SpeakString("No PC found (This is a BUG!)");
			return;
		}


		// Try to do the least intensive checks first
		if (
			// This particular spawn is allowed to respawn now
			r.spawn_delay + GetLocalInt(OBJECT_SELF, "last_spawn") <= nTS &&

			// This spawn can be detected from this distance
			GetDistanceBetween(OBJECT_SELF, oPC) <= r.search_distance &&

			GetActiveSpawnsOfTypeInDistance(sType, r.search_distance) < r.max_in_search_distance &&

			GetActiveSpawnsOfTypeInArea(sType) < r.max_per_area &&

			// Throw spawn_probability
			d100() >= r.spawn_probability &&

			// Throw search + bonus
			d20() + GetSkillRank(SKILL_SEARCH, oPC) + GetLocationBonus(oPC, r) >=
			r.dc_search * ( DETECT_MODE_PASSIVE == GetDetectMode(oPC) ?  2 : 1 ) &&

			// Throw lore + bonus
			d20() + GetSkillRank(SKILL_LORE, oPC)  + GetLocationBonus(oPC, r) >= r.dc_lore

		) {
			// We spawned something!
			nDoSpawn = TRUE;
			//dbg("Checks passed, spawning.");
			break;
		}

		//dbg("Iterating.");
		r = GetNextHiddenSpawnForType(sType);
	}


	if ( !nDoSpawn ) {
		//dbg("None found, bailing.");
		return;
	}

	//dbg("Spawning.");
	object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, r.resref, GetLocation(OBJECT_SELF));
	if ( !GetIsObjectValid(oSpawn) ) {
		//dbg("Cannot spawn '" + r.resref + "'");
		return;
	}



	SetLocalFloat(oSpawn, "search_distance", r.search_distance);
	SetLocalObject(OBJECT_SELF, "spawned_object", oSpawn);
	SetLocalObject(OBJECT_SELF, "spawning_pc", oPC);
	SetLocalInt(OBJECT_SELF, "last_spawn", nTS);
}


int GetActiveSpawnsOfTypeInDistance(string sType, float fD) {
	int n = 0;
	int near = 1;
	object o = GetNearestObjectByTag("hiddenspawn2", OBJECT_SELF, near);
	while ( GetIsObjectValid(o) ) {

		if ( GetDistanceBetween(OBJECT_SELF, o) > fD )
			break;

		if ( GetIsObjectValid(GetLocalObject(o, "spawned_object")) )
			n++;

		near++;
		o = GetNearestObjectByTag("hiddenspawn2", OBJECT_SELF, near);
	}
	return n;

}

int GetActiveSpawnsOfTypeInArea(string sType) {
	int n = 0;
	object o = GetFirstObjectInArea();
	while ( GetIsObjectValid(o) ) {
		if ( GetObjectType(o) == OBJECT_TYPE_PLACEABLE
			&& GetIsObjectValid(GetLocalObject(o, "spawned_object")) ) {
			n++;
		}

		o = GetNextObjectInArea();
	}
	return n;
}


int HideSpawn() {
	object oSpawnedObject = GetLocalObject(OBJECT_SELF, "spawned_object");

	if ( !GetIsObjectValid(oSpawnedObject) ) {
		// was harvested or otherwise killed, or already removed
		return 0;
	}

	float fSD = GetLocalFloat(oSpawnedObject, "search_distance");

	object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);

	// The player moved out of range.
	if ( !GetIsObjectValid(oPC) || GetDistanceBetween(oSpawnedObject, oPC) > fSD ) {
		DestroyObject(oSpawnedObject);
		//      dbg("Despawning.");
		return 1;
	}

	return 0;
}
