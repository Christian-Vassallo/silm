/*
 * File: _area_leave
 * A tag-execution based event system.
 * Copyright Bernard 'elven' Stoeckner.
 *
 * This code is licenced under the
 *  GNU/GPLv2 General Public Licence.
 */
#include "inc_events"
#include "inc_cleaningcrew"
#include "inc_dbplac"
#include "_gen"
#include "inc_mnx"


/*
 * This is a generic event distribution
 * script. Do not modify.
 */

void main() {
	object oPC = GetExitingObject();

	RunEventScript(OBJECT_SELF, EVENT_AREA_EXIT, EVENT_PREFIX_AREA);

	if ( GetIsPC(oPC) ) {
		string sCharName = GetName(oPC);
		string sAccountName = GetPCName(oPC);
		int nAID = GetAccountID(oPC);
		int nCID = GetCharacterID(oPC);

		mnxCommand("arealeave", sAccountName, sCharName, IntToString(nAID), IntToString(nCID));
	}

	/*int bEmpty = !GetAreaHasPlayers(oA);
	 *
	 *
	 * if (bEmpty) {
	 * 	CleanAreaForItems(oA);
	 * }*/
}
