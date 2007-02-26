#include "inc_decay"
#include "inc_cdb"
#include "inc_persist"

// Gives oPC nValue EP
void AddCombatEP(object oPC, int nValue, int bNoWarn = FALSE);

// Returns how much EP oKiller Gets for oDead
int GetKillXP(object oDead, object oKiller, int nBoni = 0);

// Returns how much EP
void GiveKillXP();



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
int GetCombatXP(object oPC) {
	int cid = GetCharacterID(oPC);
	SQLQuery("select `xp_combat` from `characters` where `id` = " + IntToString(cid) + " limit 1;");
	SQLFetch();
	int nCap = StringToInt(SQLGetData(1));
	if ( -1 == nCap ) {
		nCap = GetLegacyPersistentInt(oPC, "XP_Combat");
		// no_more_legacy
		SQLQuery("update `characters` set `xp_combat`=" +
			IntToString(nCap) + ", `legacy_xp` = 1 where `id`=" + IntToString(cid) + " limit 1;");
	}
	return nCap;
}

void SetCombatXP(object oPC, int nXP) {
	int cid = GetCharacterID(oPC);
	SQLQuery("update `characters` set `xp_combat`=" +
		IntToString(nXP) + " where `id`=" + IntToString(cid) + " limit 1;");
}

int GetCombatXPForMonth(object oPC, int nYear, int nMonth) {
	int cid = GetCharacterID(oPC);
	SQLQuery("select `xp` from `combat_xp` where `cid` = " +
		IntToString(cid) +
		" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + " limit 1;");
	if ( !SQLFetch() )
		return 0;

	int nCap = StringToInt(SQLGetData(1));
	return nCap;
}

int GetTimeXPForMonth(object oPC, int nYear, int nMonth) {
	int cid = GetCharacterID(oPC);
	SQLQuery("select sum(`xp`) as `xp` from `time_xp` where `cid` = " +
		IntToString(cid) +
		" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + ";");
	if ( !SQLFetch() )
		return 0xffffff;

	int nCap = StringToInt(SQLGetData(1));
	return nCap;
}


int GetTimeXPForDay(object oPC, int nYear, int nMonth, int nDay) {
	int cid = GetCharacterID(oPC);
	SQLQuery("select `xp` from `time_xp` where `cid` = " +
		IntToString(cid) +
		" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + 
		" and `day` = " + IntToString(nDay) + " limit 1;");
	if ( !SQLFetch() )
		return 0xffffff;

	int nCap = StringToInt(SQLGetData(1));
	return nCap;
}

void SetTimeXPForDay(object oPC, int nXP, int nYear, int nMonth, int nDay) {
	int cid = GetCharacterID(oPC);
	SQLQuery("select `xp` from `time_xp` where `cid` = " +
		IntToString(cid) +
		" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) +
		" and `day` = " + IntToString(nDay) + " limit 1;");
		
	if ( !SQLFetch() )
		SQLQuery("insert into `time_xp` (`cid`, `xp`, `year`, `month`, `day`) values(" +
			IntToString(cid) + ", " + IntToString(nXP) + ", " +
			IntToString(nYear) + ", " + IntToString(nMonth) + ", " + IntToString(nDay) + ");");
	else
		SQLQuery("update `time_xp` set `xp`=" +
			IntToString(nXP) +
			" where `cid` = " +
			IntToString(cid) +
			" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) +
			" and `day` = " + IntToString(nDay) + " limit 1;"
		);
}



void SetCombatXPForMonth(object oPC, int nXP, int nYear, int nMonth) {
	int cid = GetCharacterID(oPC);
	SQLQuery("select `xp` from `combat_xp` where `cid` = " +
		IntToString(cid) +
		" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + " limit 1;");
	if ( !SQLFetch() )
		SQLQuery("insert into `combat_xp` (`cid`, `xp`, `year`, `month`) values(" +
			IntToString(cid) + ", " + IntToString(nXP) + ", " +
			IntToString(nYear) + ", " + IntToString(nMonth) + ");");
	else
		SQLQuery("update `combat_xp` set `xp`=" +
			IntToString(nXP) +
			" where `cid` = " +
			IntToString(cid) +
			" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + " limit 1;");
}




//returns Quest EP
int GetQuestXP(object oPC) {
	return GetXP(oPC) - GetCombatXP(oPC);
}


int GetTimedXPCap(object oPC) {
	return C_COMBAT_XP_1 + GetHitDice(oPC) * C_COMBAT_XP_2;
}

//Get the number of XP the character has to spend
int GetFreeXP(object oPC) {
	int iFreeXP = GetXP(oPC) - GetBaseXPForLevel(GetHitDice(oPC));
//  if(iFreeXP > GetCombatXP(oPC)) iFreeXP = GetCombatXP(oPC);
	return iFreeXP;
}

void XP_LoseXP(object oPC, int iHowMuch, int iSilently = TRUE, int iOnlyFree = FALSE) {
	int iCombXP = GetCombatXP(oPC);

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

	GiveXPToCreature(oPC, iXP);
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
	int iXPForMonth = GetTimeXPForMonth(oPC, iYear, iMonth);
	int iXPForDay = GetTimeXPForDay(oPC, iYear, iMonth, iDay);


	if ( iXPForMonth > C_TIME_XP_MONTH )
		return;
	
	if ( iXPForDay > C_TIME_XP_DAY )
		return;

	if ( nAmount > 0 ) {
		GiveXPToCreature(oPC, nAmount);
		SetTimeXPForDay(oPC, iXPForMonth + nAmount, iYear, iMonth, iDay);
	}
}

void AddCombatEP(object oPC, int nValue, int bNoWarn = FALSE) {

	if ( GetIsDM(oPC) )
		return;

	int iCombXP = GetCombatXP(oPC);
	int iMonth = GetCalendarMonth();
	int iYear = GetCalendarYear();
	int iXPForMonth = GetCombatXPForMonth(oPC, iYear, iMonth);


	if ( iCombXP >= C_COMBAT_XP_MAX ) {
		if (!bNoWarn)
			SendMessageToPC(oPC, "Durch Kaempfen koennt Ihr nun wirklich nichts mehr lernen.");
		return;
	}
	if ( iXPForMonth > GetTimedXPCap(oPC) ) {
		if (!bNoWarn)
			SendMessageToPC(oPC, "Ihr muesstet ueber die gemachten Kampferfahrungen erstmal nachdenken.");
		return;
	}

	if ( nValue > 0 ) {
		GiveXPToCreature(oPC, nValue);
		// SetPersistentInt(oPC,"XP_Combat_cap_num",iXPForMonth + nValue);
		// SetPersistentInt(oPC,"XP_Combat",iCombXP + nValue);

		SetCombatXPForMonth(oPC, iXPForMonth + nValue, iYear, iMonth);
		SetCombatXP(oPC, iCombXP + nValue);

		if (!bNoWarn)
			SendMessageToPC(oPC, "Kampferfahrung: " +
				IntToString(iCombXP + nValue) + " (CAP: " + 
				IntToString(iXPForMonth + nValue) + ")"
			);

	}
}
