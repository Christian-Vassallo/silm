#include "inc_cdb"
#include "_gen"
#include "_chat"
#include "inc_chat_lib"


// Delegates a message oPC heard to all
// of oPCs telepathic partners that are
// set to receive it.
// oSpeakingObject can be a placeable or item,
// too. (via forcetalk)
int DelegateHeardToPartners(object oPC, object oSpeakingObject, int nMode, string sMessage);

// oPC just said sMessage in nMode, so
// delegate it to all partners that are
// set to receive it.
int DelegateOwnToPartners(object oPC, int nMode, string sMessage);

// oPC sent sMessage over the telepathic link,
// so send it over.
// Returns the number of PCs reached
int DelegateTelepathicMessageToPartners(object oPC, string sMessage);

// Sets bonds active/inactive
void SetBondsActive(object oPC, int bState);


int DelegateTelepathicMessageToPartners(object oPC, string sMessage) {
	int nCID = GetCharacterID(oPC);
	if ( !nCID )
		return 0;

	int nCount = 0;

	int nTCID;
	object oB;
	string sStart =  ColourTag(cTeal) + "*";
	string sShortName = GetName(oPC);
	string sRest = "*" + ColourTagClose() + " " + ColourisePlayerText(oPC, MODE_TALK, sMessage);
	string sMessage = sStart + sShortName + sRest;


	SQLQuery("select tcid, shortname from telepathic_bonds where cid = " +
		IntToString(nCID) + " and expire <= unix_timestamp();");

	while ( SQLFetch() ) {
		nTCID = StringToInt(SQLGetData(1));
		sShortName = SQLGetData(2);
		oB = GetPCByCID(nTCID);

		if ( GetIsPC(oB) ) {
			if ( sShortName != "" )
				sMessage = sStart + sShortName + sRest;
			SendMessageToPC(oB, sMessage);
			nCount++;
		}

	}
	if ( nCount > 0 ) {
		sMessage = sStart + GetName(oPC) + sRest;
		SendMessageToPC(oPC, sMessage);
	}
	return nCount;
}


int DelegateOwnToPartners(object oPC, int nMode, string sMessage) {
	int nCID = GetCharacterID(oPC);
	if ( !nCID )
		return 0;

	int nCount = 0;

	int nTCID;
	object oB;
	string sStart =  ColourTag(cOrange) + "*";
	string sShortName = GetName(oPC);
	string sDoesWhat = " " + ( nMode & MODE_TALK ? "spricht" : "fluestert" );
	string sRest = "*" + ColourTagClose() + " " + ColourisePlayerText(oPC, nMode, sMessage);
	string sMessage = sStart + sShortName + sDoesWhat + sRest;

	SQLQuery("select tcid, shortname from telepathic_bonds where cid = " +
		IntToString(nCID) + " and active=1 and expire <= unix_timestamp();");

	while ( SQLFetch() ) {
		nTCID = StringToInt(SQLGetData(1));
		sShortName = SQLGetData(2);
		oB = GetPCByCID(nTCID);

		if ( GetIsPC(oB) && !hears(oPC, oB, nMode & MODE_TALK ? TALKVOLUME_TALK : TALKVOLUME_WHISPER) ) {

			if ( sShortName != "" )
				sMessage = sStart + sShortName + sDoesWhat + sRest;

			SendMessageToPC(oB, sMessage);
			nCount++;
		}

	}

	return nCount;
}


int DelegateHeardToPartners(object oPC, object oSpeakingObject, int nMode, string sMessage) {
	int nCID = GetCharacterID(oPC);
	if ( !nCID )
		return 0;

	int nCount = 0;

	int nTCID;
	object oB;
	string sStart =  ColourTag(cDarkGrey) + "*";
	string sShortName = GetName(oSpeakingObject);
	string sDoesWhat = " " + ( nMode & MODE_TALK ? "spricht" : "fluestert" );
	string sRest = "*" + ColourTagClose() + " " + ColourisePlayerText(oSpeakingObject, nMode, sMessage);

	string sMessage = sStart + sShortName + sDoesWhat + sRest;

	SQLQuery("select tcid, shortname from telepathic_bonds where cid = " +
		IntToString(nCID) + " and active=1 and expire <= unix_timestamp();");

	while ( SQLFetch() ) {
		nTCID = StringToInt(SQLGetData(1));
		oB = GetPCByCID(nTCID);

		if ( GetIsPC(oB)
			&& !hears(oB, oSpeakingObject, nMode & MODE_TALK ? TALKVOLUME_TALK : TALKVOLUME_WHISPER) ) {

			SendMessageToPC(oB, sMessage);
			nCount++;
		}

	}

	return nCount;
}


void SetBondsActive(object oPC, int bState) {
	int nCID = GetCharacterID(oPC);
	if ( !nCID )
		return;

	bState = 0 != bState;

	SQLQuery("update telepathic_bonds set active=" +
		IntToString(bState) + " where cid = " + IntToString(nCID) + " and expire <= unix_timestamp();");
}

// Sends this message to all active bond partners.
// Raw version, do not modify
//int SendMessageToAllActiveBondPartners(object oPC, string sMessage, int nTalkMode = -1, int nEcho = FALSE, object oSpeaker = OBJECT_INVALID);


/*
 * int SendMessageToAllActiveBondPartners(object oPC, string sMessage, int nTalkMode = -1, int nEcho = FALSE, object oSpeaker = OBJECT_INVALID) {
 * 	int nCID = GetCharacterID(oPC);
 * 	if (!nCID)
 * 		return 0;
 *
 * 	int nCount = 0;
 *
 * 	int nTCID;
 * 	object oB;
 * 	string sShort;
 *
 * 	SQLQuery("select tcid, shortname from telepathic_bonds where cid = " + IntToString(nCID) + " and active=1 and expire <= unix_timestamp();");
 *
 * 	while (SQLFetch()) {
 * 		nTCID = StringToInt(SQLGetData(1));
 * 		sShort = SQLGetData(2);
 * 		oB = GetPCByCID(nTCID);
 * 		if (GetIsPC(oB)) {
 * 			sMessage = "(TB) " + sShort + ": " + sMessage;
 *
 * 			if (!GetIsObjectValid(oSpeaker) || !hears(oSpeaker, oB, nTalkMode))
 * 				SendMessageToPC(oB, sMessage);
 * 			nCount++;
 * 		}
 *
 * 	}
 *
 * 	if (nCount > 0 && nEcho)
 * 		SendMessageToPC(oPC, sMessage);
 *
 * 	return nCount;
 * }
 *
 */


