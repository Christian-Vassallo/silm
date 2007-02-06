#include "inc_mysql"
#include "inc_cdb"
#include "_audit"
#include "_gen"

void main() {
	object oPC = OBJECT_SELF;


	// Do not enter DMs or Non-PC-Wussies
//    if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
//        return;

	if ( GetIsDM(oPC) || GetIsDMPossessed(oPC) )
		return;

	string
	sChar = SQLEscape(GetName(oPC)),
	sAccount = SQLEscape(GetPCName(oPC)),
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


	SQLQuery(
		"update `accounts` set `total_time`=`total_time` + (unix_timestamp() - (select `current_time` from `characters` where `id`='"
		+ sID + "' limit 1)) where `id`='" + sAID + "' limit 1;");
	SQLQuery(
		"update `characters` set `total_time`=`total_time` + (unix_timestamp() - `current_time`), `current_time`=0 where `id`='"
		+ sID + "';");
}
