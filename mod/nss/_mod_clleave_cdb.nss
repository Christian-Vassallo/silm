#include "inc_pgsql"
#include "inc_cdb"
#include "inc_audit"
#include "_gen"

void main() {
	object oPC = OBJECT_SELF;


	// Do not enter DMs or Non-PC-Wussies
//    if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
//        return;

	if ( GetIsDM(oPC) || GetIsDMPossessed(oPC) )
		return;

	string
	sChar = pE(GetName(oPC)),
	sAccount = pE(GetPCName(oPC)),
	sKey = GetPCPublicCDKey(oPC),
	sIP = GetPCIPAddress(oPC),
	sDesc = "";    //SQLEscape(GetDescription(oPC));


	int nAID = GetAccountID(oPC);
	int nCID = GetCharacterID(oPC);

	if ( 0 == nCID ) {
		audit("cdb", oPC, "Cannot find character", "cdb");
		SendMessageToAllDMs("Warning: Query in _mod_clenter_cdb failed: Cannot find character.");
		return;
	}

	string sID = IntToString(nCID);
	string sAID = IntToString(nAID);


/*	pQ(
		"update accounts set total_time = total_time + (unix_timestamp() - (select current_time from characters where id='"
		+ sID + "' limit 1)) where id='" + sAID + "' limit 1;");*/
	SQLQuery(
		"update characters set total_time = total_time + (now() - login_time), login_time = null where id='"
		+ sID + "';");
}
