/*
 * Aufenthalts-XP
 *  Assigns TIME_XP_AMOUNT each TIME_XP_INTERVAL seconds.
 *  Gives no XP if you're alone on the server.
*/

#include "_gen"
#include "inc_mysql"
#include "inc_xp_handling"


void main() {
	int nPlayerCount = GetPCCount(OBJECT_INVALID, 0) - GetPCCount(OBJECT_INVALID, 1); 
	int nTS = GetUnixTimestamp();
	int nLastForPlayer = 0;
	int nPlayerLastSaid = 0;
	location lLastPlayerLocation;
	location lPlayerLocation;

	// Do not give XP for being alone. Hard but true.
	if (0 == GetLocalInt(GetModule(), "time_xp_ovr") && nPlayerCount == 1)
		return;

	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC)) {
		
		// Do not give XP for being AFK.
		if (!GetIsDM(oPC) && !GetLocalInt(oPC, "afk")) {
			nLastForPlayer = GetLocalInt(oPC, "last_time_xp_given");
			nPlayerLastSaid = gvGetInt("time_xp_max_message_time") == 0 ? nTS : GetLocalInt(oPC,"last_message");
			/*lLastPlayerLocation = GetLocalLocation(oPC, "last_time_xp_location");
			lPlayerPosition = GetLocation(oPC);*/
			

			if ( 
				(nTS - gvGetInt("time_xp_interval") > nLastForPlayer) &&
				(nTS - gvGetInt("time_xp_interval") <= nPlayerLastSaid) 
			) {
				GiveTimeXP(oPC, gvGetInt("time_xp_amount"));
				SetLocalInt(oPC, "last_time_xp_given", nTS);
			}
		}

		oPC = GetNextPC();
	}
}
