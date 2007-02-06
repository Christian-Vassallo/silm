#include "inc_mysql"
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
	sAccount = SQLEscape(GetPCPlayerName(oPC)),
	sChar = SQLEscape(GetName(oPC)),
	sText = SQLEscape(sMessage),
	sArea = SQLEscape(GetTag(GetArea(oPC))),

	sAccTo = SQLEscape(GetPCPlayerName(oTo)),
	sCharTo = SQLEscape(GetName(oTo));

	SQLQuery(
		"insert into `chatlogs` (`account`,`character`,`account_s`,`character_s`,`taid`,`tcid`,`taccount`,`tcharacter`,`area`,`text`,`mode`) values("
		+
		IntToString(nAID) + ", " + IntToString(nCID) + ", " + sAccount + ", " + sChar + ", " +
		IntToString(nTAID) + ", "  + IntToString(nTCID) + ", " + sAccTo + ", " + sCharTo + ", " +
		sArea + ", " + sText + ", " + IntToString(nMode) +
		");");

	// SQLQuery("delete from `chatlog` order by `timestamp` asc limit 0,500;");

}
