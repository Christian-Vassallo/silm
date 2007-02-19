/*
 * Aufenthalts-XP
 *  Assigns TIME_XP_AMOUNT each TIME_XP_INTERVAL seconds.
 *  Gives no XP if you're alone on the server.
*/

#include "_const"
#include "_gen"
#include "inc_mysql"
#include "inc_xp_handling"
const int
// Results in 96XP/4h
TIME_XP_AMOUNT = 2,
TIME_XP_INTERVAL = 60 * 5, 

// only give XP if player said something in the last n seconds.
TIME_XP_MAX_MESSAGE_TIME = 60 * 3,

// only if the player moved in the last n seconds
TIME_XP_MAX_MOVE_TIME = 0;


void main() {
	int nPlayerCount = GetPCCount(OBJECT_INVALID, 0) - GetPCCount(OBJECT_INVALID, 1); 
	int nTS = GetUnixTimestamp();
	int nLastForPlayer = 0;
	int nPlayerLastSaid = 0;
	location lLastPlayerLocation;
	location lPlayerLocation;

	// Do not give XP for being alone. Hard but true.
	if (nPlayerCount == 1)
		return;

	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC)) {
		
		// Do not give XP for being AFK.
		if (!GetIsDM(oPC) && !GetLocalInt(oPC, "afk")) {
			nLastForPlayer = GetLocalInt(oPC, "last_time_xp_given");
			nPlayerLastSaid = GetLocalInt(oPC,"last_message");
			/*lLastPlayerLocation = GetLocalLocation(oPC, "last_time_xp_location");
			lPlayerPosition = GetLocation(oPC);*/
			

			if ( 
				(nTS - TIME_XP_INTERVAL > nLastForPlayer) &&
				(nTS - TIME_XP_MAX_MESSAGE_TIME <= nPlayerLastSaid) 
			) {
				GiveTimeXP(oPC, TIME_XP_AMOUNT);
				SetLocalInt(oPC, "last_time_xp_given", nTS);
			}
		}

		oPC = GetNextPC();
	}
}
