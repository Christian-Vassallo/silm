#include "inc_cdb"
#include "inc_chat"
#include "_gen"
#include "inc_mnx"
#include "inc_limbo"
#include "inc_audit"
#include "inc_currency"

#include "_buildinfo"

void MnxNotify(object oPC);

void main() {
	object oPC = GetEnteringObject();

	ChatPCin(oPC);

	int nGold = Money2Value(CountCreatureMoney(oPC, 0));

	audit("login", oPC, audit_fields("key", GetPCPublicCDKey(oPC), "xp", IntToString(GetXP(oPC)), "gold",
			IntToString(nGold)));

	SetLocalString(oPC, "player_name", GetPCPlayerName(oPC));

	SendMessageToPC(oPC, "Repository: " + REPOSITORY);
	SendMessageToPC(oPC, "Revision: " + REVISION);
	SendMessageToPC(oPC, "Commited on: " + COMMIT_ON);
	SendMessageToPC(oPC, "Built on: " + BUILD_ON);

	struct mnxRet r = mnxRun(oPC, "uptime");
	if (!r.error)
		SendMessageToPC(oPC, "Uptime: " + r.ret);
	// SendMessageToPC(oPC, "");


	// Check the bleedin cd key
//    SQLQuery("
	//if (GetIsDM(oPC) && !GetIsDMAllowed(oPC)) {
	// DelayCommand(10.0, BootPC(oPC));
	//return;
	//    SendMessageToPC(oPC, "Dieser Account wurde nicht fuer den DM-Zugang freigeschalten. (Debugnachricht, bitte Elven melden)");
	//}



	DelayCommand(1.0f, ExecuteScript("_mod_clenter_cdb", oPC));

	// DelayCommand(1.2f, ExecuteScript("_mod_clenter_onl", oPC));

	//Must come first!!!
	ExecuteScript("login_1stenter", oPC);
	ExecuteScript("login_subrace", oPC);
	ExecuteScript("login_pcdata", oPC);
	ExecuteScript("login_craftsys", oPC);
	ExecuteScript("login_misc", oPC);
	ExecuteScript("login_update", oPC);
	ExecuteScript("login_corpse", oPC);
	ExecuteScript("login_bodyparts", oPC);

	ExecuteScript("login_slogan", oPC);

	ExecuteScript("login_effects", oPC);


	DelayCommand(1.0f, MnxNotify(oPC));


	if ( !GetIsDMOnline() )
		SendMessageToPC(oPC,
			"Derzeit ist kein SL im Spiel online. Du kannst jedoch SLs trotzdem ueber den SL-Channel erreichen; deine Nachrichten werden weitergeleitet.");


	// XXX hotfix
	SetLocalInt(oPC, "bandage", 0);
	SetLocalInt(oPC, "medicine", 0);

	SetLocalInt(oPC, "message_count", 0);

	// Remove the language tokens.
	int i;
	for ( i = 0; i < 30; i++ )
		DestroyObject(GetItemPossessedBy(oPC, "lang_" + IntToString(i + 1)));
	/* Mappins */
	/*int count = RestoreMapPinsForPlayer(oPC);
	 * if (count)
	 * 	SendMessageToPC(oPC, IntToString(count) + " Map-Pins geladen und platziert.");*/

	if ( !GetIsDM(oPC) && !GetIsObjectValid(GetItemPossessedBy(oPC, "pc_follow")) )
		CreateItemOnObject("pc_follow", oPC, 1);

//    if (!GetIsObjectValid(GetItemPossessedBy(oPC, "pc_walkrun")))
//        CreateItemOnObject("pc_walkrun", oPC, 1);
	// DestroyObject(GetItemPossessedBy(oPC, "pc_walkrun"));

	// Copy player to limbo, kthnx.
	object oLimbo = GetObjectByTag(LIMBO_WAYPOINT);

	if ( GetIsObjectValid(oLimbo) ) {
		location lLimbo = GetLocation(oLimbo);
		object o = GetFirstObjectInArea(GetArea(oLimbo));
		int bFound = FALSE;

		while ( GetIsObjectValid(o) ) {
			if ( GetIsCreature(o) ) {
				if ( GetName(o) == GetName(oPC) ) {
					bFound = TRUE;
					break;
				}
			}
			o = GetNextObjectInArea(GetArea(oLimbo));
		}

		if ( !bFound ) {
			object oNew = CopyObject(oPC, lLimbo);
			ChangeToStandardFaction(oNew, STANDARD_FACTION_COMMONER);
		}
	}

}

void MnxNotify(object oPC) {
	string sCharName = GetName(oPC);
	string sAccountName = GetPCName(oPC);
	int nAID = GetAccountID(oPC);
	int nCID = GetCharacterID(oPC);
	string bIsDM = BoolToString(GetIsDM(oPC));

	struct mnxRet ret = mnxCmd("cliententer", sAccountName, sCharName, IntToString(nAID), IntToString(nCID),
							bIsDM, GetPCIPAddress(oPC), GetPCPublicCDKey(oPC));
	if ( ret.error )
		return;

	string
	sIP = GetPCIPAddress(oPC),
	sHost = ret.ret,
	sKey = GetPCPublicCDKey(oPC);

	SendMessageToAllDMs("enter: '" +
		sAccountName +
		"'(" +
		IntToString(nAID) +
		") '" + sCharName + "'(" + IntToString(nCID) + "), " + sIP + " -> " + sHost + "/" + sKey);
}

