#include "_gen"
#include "inc_decay"
#include "inc_cdb"
#include "inc_persist"
#include "inc_setting"
#include "inc_pgsql"

// Gives oPC nValue EP
void AddCombatXP(object oPC, int nValue, int bNoWarn = FALSE);

// Returns how much EP oKiller Gets for oDead
int GetKillXP(object oDead, object oKiller);


// Gives nXP to oPlayer, returning the
// given value (minus penalties).
// Sets various other variables, including
// those concering xpguard. Dont mix with
//  GiveXPToCreature()!
int GiveXP(object oPlayer, int nXP, int bMultiClassPenalties = TRUE);


// Returns how much EP
void GiveKillXP();


// Used by hb_xp_guard to differentiate between GM given XP
// and script given XP
void _AddNonGMXPDifference(object oPC, int nValue, int nType = 0);


// Gives nAmount to oPC, but not above the CAP.
void GiveTimeXP(object oPC, int nAmount);

// Returns how much XP this player has got THIS MONTH through Auto XP.
int GetTimeXPForDay(object oPC, int nYear, int nMonth, int nDay);
// ..
void SetTimeXPForDay(object oPC, int nXP, int nYear, int nMonth, int nDay);

// Returns CombatEP
int GetCombatXP(object oPC);

void SetCombatXP(object oPC, int nXP);

//returns CAP
int GetTimedXPCap(object oPC);

int GetCombatXPForMonth(object oPC, int nYear, int nMonth);

// This requires an unique key on xp, year, month or your database
// will be littered with stray inserts
void SetCombatXPForMonth(object oPC, int nXP, int nYear, int nMonth);



int GiveXP(object oPlayer, int nXP, int bMultiClassPenalties = TRUE) {
	if (nXP < 0 || !GetIsPC(oPlayer) || GetIsDM(oPlayer))
			return 0;
	
	int now = GetXP(oPlayer);
	if (bMultiClassPenalties)
		GiveXPToCreature(oPlayer, nXP);
	else
		SetXP(oPlayer, now + nXP);

	now = GetXP(oPlayer) - now;
	
	_AddNonGMXPDifference(oPlayer, now);
	return now;
}

//Get the ECL of the character
int SR_GetECL(object oPC) {
	string sSubrace = GetLocalString(oPC, "SR_Subrace");
	return GetLocalInt(GetModule(), "SR_ECL_" + sSubrace);
}

//Modify the XP to award according to ECL
//Possibly support for favoured class according to subraces?
int ModifyXP(object oPC, int iXP) {
	int iLevel = GetHitDice(oPC);
	return ( iXP * iLevel ) / ( iLevel + SR_GetECL(oPC) );
}

//Get the XP for the character to reach the current level
int GetBaseXPForLevel(int iLevel) {
	return 500 * ( iLevel - 1 ) * iLevel;
}

//returns Combat EP
int GetLegacyCombatXP(object oPC) {
	pB();
	int cid = GetCharacterID(oPC);
	pQ("select xp_combat from characters where id = " + IntToString(cid) + ";");
	if (!pF())
		return 0;
	int nCap = StringToInt(pG(1));
	if ( -1 == nCap ) {
		nCap = GetLegacyPersistentInt(oPC, "XP_Combat");
		// no_more_legacy
		pQ("update characters set  xp_combat = " +
			IntToString(nCap) + ", legacy_xp = 1 where id =" + IntToString(cid) + ";");
	}
	pC();
	return nCap;
}

void SetLegacyCombatXP(object oPC, int nXP) {
	int cid = GetCharacterID(oPC);
	pQ("update characters set xp_combat=" +
		IntToString(nXP) + " where id=" + IntToString(cid) + ";");
}



int GetCategoryXPForMonth(object oPC, string sCategory, int nYear, int nMonth) {
	int cid = GetCharacterID(oPC);
	pQ("select sum(xp) as xp from " + sCategory + "_xp where character = " +
		IntToString(cid) +
		" and year = " + IntToString(nYear) + " and month = " + IntToString(nMonth) + ";");
	if ( !pF() ) {
		return 0;
	}

	int nCap = StringToInt(pG(1));
	return nCap;
}


int GetCategoryXPForDay(object oPC, string sCategory, int nYear, int nMonth, int nDay) {
	int cid = GetCharacterID(oPC);
	pQ("select xp from " + sCategory + "_xp where character = " +
		IntToString(cid) +
		" and year = " + IntToString(nYear) + " and month = " + IntToString(nMonth) + 
		" and day = " + IntToString(nDay) + ";");
	if ( !pF() ) {
		return 0;
	}
	int nCap = StringToInt(pG(1));
	return nCap;
}

void SetCategoryXPForDay(object oPC, string sCategory, int nXP, int nYear, int nMonth, int nDay) {
	int cid = GetCharacterID(oPC);
	pQ("select xp from " + sCategory + "_xp where character = " +
		IntToString(cid) +
		" and year = " + IntToString(nYear) + " and month = " + IntToString(nMonth) +
		" and day = " + IntToString(nDay) + ";");
		
	if ( !pF() )
		pQ("insert into " + sCategory + "_xp (character, xp, year, month, day) values(" +
			IntToString(cid) + ", " + IntToString(nXP) + ", " +
			IntToString(nYear) + ", " + IntToString(nMonth) + ", " + IntToString(nDay) + ");");
	else
		pQ("update " + sCategory + "_xp set xp = " +
			IntToString(nXP) +
			" where character = " +
			IntToString(cid) +
			" and year = " + IntToString(nYear) + " and month = " + IntToString(nMonth) +
			" and day = " + IntToString(nDay) + ";"
		);
}



//returns Quest EP
int GetQuestXP(object oPC) {
	return GetXP(oPC) - GetCombatXP(oPC);
}


//Get the number of XP the character has to spend
int GetFreeXP(object oPC) {
	int iFreeXP = GetXP(oPC) - GetBaseXPForLevel(GetHitDice(oPC));
//  if(iFreeXP > GetCombatXP(oPC)) iFreeXP = GetCombatXP(oPC);
	return iFreeXP;
}

void XP_LoseXP(object oPC, int iHowMuch, int iSilently = TRUE, int iOnlyFree = FALSE) {
	int iCombXP = GetLegacyCombatXP(oPC);

	if ( iOnlyFree && iHowMuch > GetFreeXP(oPC) )
		iHowMuch = GetFreeXP(oPC);

	/* "XP-Verlust" */
	if ( !iSilently )
		DelayCommand(4.0, FloatingTextStrRefOnCreature(58299, oPC, FALSE));

	SetXP(oPC, GetXP(oPC) - iHowMuch);

	/* Lost XP will be subtracted from the combat XP */
	SetLocalInt(oPC, "XP_Combat", iCombXP - iHowMuch);
}

void XP_RewardQuestXP(object oPC, int iXP) {
	int iQuestXP = GetQuestXP(oPC);


	iXP = ModifyXP(oPC, iXP);

	//Award at least one XP
	if ( !iXP ) iXP = 1;

	GiveXP(oPC, iXP);
	ExportSingleCharacter(oPC);
}

/*
  * GetKillXP
  * Calculates Kill XP according CR difference and global settings
  * Returns Kill XP as int
*/
int GetKillXP(object oDead, object oChar) {
    float nCRDead = GetChallengeRating(oDead);
    //No XP if CR < 1. No levelling up on rabbits, you!
    if (nCRDead < 1f) return 0;

    float nCRChar = IntToFloat(GetHitDice(oChar));
    float nXPScale = gvGetFloat("combat_xp_scale");
    float nMaxCRDiff = IntToFloat(gvGetInt("combat_xp_max_cr_difference"));
    float nDiff;
    int nXP;
    float nBaseXP = 30f;
    float nXPperDiff = 4f;

    nDiff = nCRDead - nCRChar;

    d("GetKillXP(): nDiff = " + FloatToString(nDiff) + "(" + FloatToString(nCRDead) + " - " + FloatToString(nCRChar) + ")", "combat_xp");
    //No XP if CR difference is way out of bounds. Fight someone of yer own size, crivens!
    if (nDiff > nMaxCRDiff || nDiff < nMaxCRDiff * -1.0)
		return 0;

    //Unscaled XP is nBaseXP + nXPperDiff per CR difference, multiplied by global setting.
    nXP = FloatToInt((nDiff * nXPperDiff + nBaseXP) * nXPScale);
    d("GetKillXP(): nXP = " + IntToString(nXP), "combat_xp");
    return nXP;
}


//On Monster death: distributes XP to players
void GiveKillXP() {
 object oPC = GetLastKiller();

 if ( GetIsDM(oPC) )
  return;

//Checks PCs egligible for kill XP (i.e. nearby)
 object oChar = GetFirstFactionMember(oPC);
 int nXP;
 while ( GetIsObjectValid(oChar) ) {
  //PC landing killing blow gets XP
  if ( oPC == oChar ||
  //PC is within a certain distance and has line of sight
  (LineOfSightObject(oChar, OBJECT_SELF) &&
    GetDistanceBetween(oChar, OBJECT_SELF) <= 50.0 ) ) {
    int nLevel = GetHitDice(oChar);
    nXP = GetKillXP(OBJECT_SELF, oChar);
	d("GiveKillXP(): to = " + GetName(oChar) + ", xp = " + IntToString(nXP), "combat_xp");
    AddCombatXP(oChar, nXP);
  }
  oChar = GetNextFactionMember(oPC);
 }
}



void GiveTimeXP(object oPC, int nAmount) {
	if ( GetIsDM(oPC) )
		return;
	
	struct RealTime r = GetRealTime();
	if (r.error)
		return;

	int iDay = r.day;
	int iMonth = r.month; 
	int iYear = r.year; 
	int iXPForMonth = GetCategoryXPForMonth(oPC, "time", iYear, iMonth);
	int iXPForDay = GetCategoryXPForDay(oPC, "time", iYear, iMonth, iDay);


	if ( iXPForMonth > gvGetInt("time_xp_limit_month") )
		return;
	
	if ( iXPForDay > gvGetInt("time_xp_limit_day") )
		return;

	if ( nAmount > 0 ) {
		GiveXP(oPC, nAmount, FALSE);
		SetCategoryXPForDay(oPC, "time", iXPForDay + nAmount, iYear, iMonth, iDay);
	}
}


//It adds combat XP. To character, and the DB.
//Now go away.
void AddCombatXP(object oPC, int nValue, int bNoWarn = FALSE) {
	if ( GetIsDM(oPC) )
		return;

	int iCombXP = GetLegacyCombatXP(oPC);

	struct RealTime r = GetRealTime();
	if (r.error)
		return;

	float nECLAdj = gvGetFloat("combat_xp_ecl_adjustment");
	int iMonthCap = gvGetInt("combat_xp_limit_month");
	int iDayCap = gvGetInt("combat_xp_limit_day");

	int iDay = r.day;
	int iMonth = r.month;
	int iYear = r.year;
	int iXPForMonth = GetCategoryXPForMonth(oPC, "combat", iYear, iMonth);
	int iXPForDay = GetCategoryXPForDay(oPC, "combat", iYear, iMonth, iDay);

	float nECL = IntToFloat(SR_GetECL(oPC));
	
	d("ecl = " + FloatToString(nECL) + ", xp_month = " + IntToString(iXPForMonth) + ", xp_day = " + IntToString(iXPForDay), "combat_xp");

	if ( iCombXP >= gvGetInt("combat_xp_max" ) ) {
		if (!bNoWarn)
			SendMessageToPC(oPC, "Durch Kaempfen koennt Ihr nun wirklich nichts mehrlernen.");
		return;
	}

	//Checks monthly combat XP cap, adjusted by ECL
	float fUpperLimit = IntToFloat(iMonthCap) * (1.0 - (nECL * nECLAdj));
	d("montly_cap = " + IntToString(iMonthCap) + ", limit = " + FloatToString(fUpperLimit), "combat_xp");
	if ( iMonthCap > 0 && IntToFloat(iXPForMonth) > fUpperLimit ) {
		if (!bNoWarn)
		SendMessageToPC(oPC, "Ihr muesstet ueber die gemachten Kampferfahrungenerstmal nachdenken.");
		return;
	}

	//Checks daily combat XP cap, adjusted by ECL
	fUpperLimit = IntToFloat(iDayCap) * (1.0 - (nECL * nECLAdj));
	d("daily_cap = " + IntToString(iDayCap) + ", limit = " + FloatToString(fUpperLimit), "combat_xp");
	if ( iDayCap > 0 && IntToFloat(iXPForDay) > fUpperLimit ) {
		if (!bNoWarn)
			SendMessageToPC(oPC, "Ihr muesstet ueber die gemachten Kampferfahrungenerstmal nachdenken. (Tageslimit)");
		return;
	}

	//Adds the XP, duh!
	if ( nValue > 0 ) {
		nValue = GiveXP(oPC, nValue);

		SetCategoryXPForDay(oPC, "combat", iXPForDay + nValue, iYear, iMonth, iDay);
		SetLegacyCombatXP(oPC, iCombXP + nValue);

		if (!bNoWarn)
			SendMessageToPC(oPC, "Kampferfahrung: " +
				IntToString(iCombXP + nValue) + " (CAP: " +
				IntToString(iXPForMonth + nValue) + ")"
			);

	}
}







void _AddNonGMXPDifference(object oPC, int nValue, int nType = 0) {
	int nVal = GetLocalInt(oPC, "xpg_other_xp");
	SetLocalInt(oPC, "xpg_other_xp", nVal + nValue);
}
