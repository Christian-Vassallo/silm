/*
 * File: _area_enter
 * A tag-execution based event system.
 * Copyright Bernard 'elven' Stoeckner.
 *
 * This code is licenced under the
 *  GNU/GPLv2 General Public Licence.
 */
#include "_gen"
#include "inc_mysql"

#include "inc_events"
#include "inc_dbplac"

#include "inc_mnx"
#include "inc_mnx_temp"



#include "inc_track"


void ShowWeather(object oArea, object oPC);


void main() {

	object oPC = GetEnteringObject();
	object oArea = GetArea(oPC);

	//if (!GetLocalInt(oArea, "NoExplore"))

	if ( GetIsPC(oPC) )
		ExploreAreaForPlayer(oArea, oPC, TRUE);


	if ( GetIsPC(oPC) )
		LoadPlaciesForArea(oArea);

	// Show temperature
	if ( GetIsPC(oPC) ) {
		ShowAndUpdateWeather(oArea, oPC);
	}


	if ( GetIsPC(oPC) && !GetIsDM(oPC) ) {
		//Spuren hinterlassen starten
		trackDebug(GetName(oPC) + ": new thread starting?");
		if ( GetLocalInt(oPC, "hasTrackHB") == FALSE && GetLocalInt(GetModule(), "tracking") == 1 ) {
			trackDebug("yep.");
			SetLocalInt(oPC, "hasTrackHB", TRUE);
			SetLocalLocation(oPC, "lastTrackLocation", GetLocation(oPC));
			leaveTracksHB(oPC);
		}
	}

	if ( GetIsPC(oPC) ) {
		string sCharName = GetName(oPC);
		string sAccountName = GetPCName(oPC);
		int nAID = GetAccountID(oPC);
		int nCID = GetCharacterID(oPC);

		mnxCommand("areaenter", sAccountName, sCharName, IntToString(nAID), IntToString(nCID), GetResRef(
				oArea), GetTag(oArea), GetName(oArea));
	}




	RunEventScript(OBJECT_SELF, EVENT_AREA_ENTER, EVENT_PREFIX_AREA);

}






