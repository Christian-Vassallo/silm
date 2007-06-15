#include "inc_pgsql"
#include "inc_cdb"

void ChatLog(object oPC, int nMode, string sMessage, object oTo);


void ChatLog(object oPC, int nMode, string sMessage, object oTo) {
	// For now, do not log npc
	// if (!GetIsPC(oPC))
	//     return;
	// Log NPCs too.

	int nDontLogForArea = GetLocalInt(GetArea(oPC), "dont_lastlog") == 1;

	if ( nDontLogForArea )
		return;

	int
	nAID = GetAccountID(oPC),
	nCID = GetCharacterID(oPC),
	nTAID = GetAccountID(oTo),
	nTCID = GetCharacterID(oPC);

	string
	sAccount = pE(GetPCPlayerName(oPC)),
	sChar = pE(GetName(oPC)),
	sText = pE(sMessage),
	sArea = pE(GetTag(GetArea(oPC))),

	sAccTo = pE(GetPCPlayerName(oTo)),
	sCharTo = pE(GetName(oTo));

	pQ(
		"insert into chatlogs (account,character,account_s,character_s,t_account,t_character,t_account_s,t_character_s,area,text,mode) values("
		+
		IntToString(nAID) + ", " + IntToString(nCID) + ", " + sAccount + ", " + sChar + ", " +
		IntToString(nTAID) + ", "  + IntToString(nTCID) + ", " + sAccTo + ", " + sCharTo + ", " +
		sArea + ", " + sText + ", " + IntToString(nMode) +
		");");

	// SQLQuery("delete from chatlog order by timestamp asc limit 0,500;");

}
