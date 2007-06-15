#include "inc_decay"
#include "inc_cdb"
#include "inc_persist"
#include "inc_setting"
#include "inc_pgsql"

// Gives oPC nValue EP
void AddCombatEP(object oPC, int nValue, int bNoWarn = FALSE);

// Returns how much EP oKiller Gets for oDead
int GetKillXP(object oDead, object oKiller, int nBoni = 0);


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
	pF();
	int nCap = StringToInt(SQLGetData(1));
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

int GetKillXP(object oDead, object oChar, int nBoni = 0) {
	int nCRDead = FloatToInt(GetChallengeRating(oDead));
	int nCRChar = GetHitDice(oChar) + SR_GetECL(oChar);
	int nXP;
	int nDiff = nCRChar - nCRDead - nBoni;

	if ( nDiff > 6 ) nXP = 0;
	//else if(nDiff == 8) nXP = 2;
	//else if(nDiff == 7) nXP = 5;
	else if ( nDiff == 6 ) nXP = 10;
	else if ( nDiff == 5 ) nXP = 12;
	else if ( nDiff == 4 ) nXP = 15;
	else if ( nDiff == 3 ) nXP = 18;
	else if ( nDiff == 2 ) nXP = 20;
	else if ( nDiff == 1 ) nXP = 22;
	else if ( nDiff == 0 ) nXP = 25;
	else if ( nDiff == -1 ) nXP = 28;
	else if ( nDiff == -2 ) nXP = 30;
	else if ( nDiff == -3 ) nXP = 32;
	else if ( nDiff == -4 ) nXP = 35;
	else if ( nDiff == -5 ) nXP = 38;
	else if ( nDiff == -6 ) nXP = 40;
	else if ( nDiff == -7 ) nXP = 45;
	else if ( nDiff <= -8 ) nXP = 50;
	//SendMessageToAllDMs("Monster-HG="+ IntToString(nCRDead) +" / Char-HG="+ IntToString(nCRChar) +" / EP="+ IntToString(nXP));
	if ( GetChallengeRating(oDead) < 1.0 ) nXP = 0; // no EP for HS0.x
	return nXP;
}

void GiveKillXP() {
	object oPC = GetLastKiller();

	if ( GetIsDM(oPC) )
		return;

	object oChar = GetFirstFactionMember(oPC);
	int nXP;
	while ( GetIsObjectValid(oChar) ) {
		if ( oPC == oChar
			|| ( LineOfSightObject(oChar, OBJECT_SELF)
				&& GetDistanceBetween(oChar, OBJECT_SELF) <= 50.0 ) ) {
			int nLevel = GetHitDice(oChar) + SR_GetECL(oChar);
			//SendMessageToAllDMs(IntToString(nLevel) +" / "+ IntToString(GetFactionAverageLevel(oChar)));
			if ( nLevel < GetFactionAverageLevel(oChar) ) {
				nXP = GetKillXP(OBJECT_SELF, oChar, 1);
				AddCombatEP(oChar, nXP);
			} else {
				nXP = GetKillXP(OBJECT_SELF, oChar);
				AddCombatEP(oChar, nXP);
			}
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

void AddCombatEP(object oPC, int nValue, int bNoWarn = FALSE) {

	if ( GetIsDM(oPC) )
		return;

	int iCombXP = GetLegacyCombatXP(oPC);
	
	struct RealTime r = GetRealTime();
	if (r.error)
		return;

	int iDay = r.day;
	int iMonth = r.month; 
	int iYear = r.year; 
	int iXPForMonth = GetCategoryXPForMonth(oPC, "combat", iYear, iMonth);
	int iXPForDay = GetCategoryXPForDay(oPC, "combat", iYear, iMonth, iDay);

	if ( iCombXP >= gvGetInt("combat_xp_max" ) ) {
		if (!bNoWarn)
			SendMessageToPC(oPC, "Durch Kaempfen koennt Ihr nun wirklich nichts mehr lernen.");
		return;
	}

	if ( gvGetInt("combat_xp_limit_month") > 0 && iXPForMonth > gvGetInt("combat_xp_limit_month") ) {
		if (!bNoWarn)
			SendMessageToPC(oPC, "Ihr muesstet ueber die gemachten Kampferfahrungen erstmal nachdenken.");
		return;
	}
	
	if ( gvGetInt("combat_xp_limit_day") > 0 && iXPForMonth > gvGetInt("combat_xp_limit_month") ) {
		if (!bNoWarn)
			SendMessageToPC(oPC, "Ihr muesstet ueber die gemachten Kampferfahrungen erstmal nachdenken.");
		return;
	}

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
