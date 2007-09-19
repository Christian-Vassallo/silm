#include "inc_pgsql"
#include "inc_cdb"


void AddGMXP(object oPlayer, string sGMs, int nAmount);


void AddGMXP(object oPlayer, string sGMs, int nAmount) {
	
	int nCID = GetCharacterID(oPlayer);
	if (!nCID)
		return;

	pQ("insert into gm_xp (character,account_gms,xp) values( " + IntToString(nCID) + 
		", '{ " + sGMs + 
		"}', " + IntToString(nAmount) + " );");

}

void CheckXP(object oPC, string sGMsOnline) {
	int nLastCheckedXP = GetLocalInt(oPC, "xpg_last_xp");
	
	int nOtherXPDifference = GetLocalInt(oPC, "xpg_other_xp");

	int nCurrentXP = GetXP(oPC);
	
	SetLocalInt(oPC, "xpg_last_xp", nCurrentXP);
	SetLocalInt(oPC, "xpg_other_xp", 0);

	// Player is newly joined
	if (0 == nLastCheckedXP)
		nLastCheckedXP = nCurrentXP;

	
	int nUnaccountedDifference = (nCurrentXP - nLastCheckedXP - nOtherXPDifference);

	// Nothing to be done for now
	if (0 == nUnaccountedDifference || -3 == nUnaccountedDifference)
		return;

	AddGMXP(oPC, sGMsOnline, nUnaccountedDifference);
}

void main() {
	object oPC = GetFirstPC();
	string gms = "";
	
	int nAID = 0;

	while (GetIsObjectValid(oPC)) {
		if (GetIsDM(oPC)) {
			nAID = GetAccountID(oPC);
			gms += IntToString(nAID) + ", ";
		}
		oPC = GetNextPC();
	}

	if (GetStringLength(gms) > 0)
		gms = GetStringLeft(gms, GetStringLength(gms) - 2);

	oPC = GetFirstPC();
	while (GetIsObjectValid(oPC)) {

		if (!GetIsDM(oPC) && GetIsPC(oPC)) {
			CheckXP(oPC, gms);
		}
		oPC = GetNextPC();
	}
}
