#include "inc_decay"
#include "inc_cdb"
#include "inc_persist"

// Gives oPC nValue EP
void AddCombatEP(object oPC, int nValue, int bNoWarn = FALSE);

// Returns how much EP oKiller Gets for oDead
int GetKillXP(object oDead, object oKiller, int nBoni = 0);

// Returns how much EP
void GiveKillXP();


int GetTimeXPCap();

// Gives nAmount to oPC, but not above the CAP.
void GiveTimeXP(object oPC, int nAmount);

// Returns how much XP this player has got THIS MONTH through Auto XP.
int GetTimeXPForMonth(object oPC, int nYear, int nMonth);
// ..
void SetTimeXPForMonth(object oPC, int nXP, int nYear, int nMonth);

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
	SQLQuery("select `xp` from `time_xp` where `cid` = " +
		IntToString(cid) +
		" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + " limit 1;");
	if ( !SQLFetch() )
		return 0;

	int nCap = StringToInt(SQLGetData(1));
	return nCap;
}

void SetTimeXPForMonth(object oPC, int nXP, int nYear, int nMonth) {
	int cid = GetCharacterID(oPC);
	SQLQuery("select `xp` from `time_xp` where `cid` = " +
		IntToString(cid) +
		" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + " limit 1;");
	if ( !SQLFetch() )
		SQLQuery("insert into `time_xp` (`cid`, `xp`, `year`, `month`) values(" +
			IntToString(cid) + ", " + IntToString(nXP) + ", " +
			IntToString(nYear) + ", " + IntToString(nMonth) + ");");
	else
		SQLQuery("update `time_xp` set `xp`=" +
			IntToString(nXP) +
			" where `cid` = " +
			IntToString(cid) +
			" and `year` = " + IntToString(nYear) + " and `month` = " + IntToString(nMonth) + " limit 1;");
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
/*
 * void XP_RewardCombatXP(object oPC, int iXP)
 * {
 * int iCombXP = GetCombatXP(oPC);
 * int iCombXPCap = GetPersistentInt(oPC,"XP_Combat_cap_num");
 * int iCombXPMon = GetPersistentInt(oPC,"XP_Combat_cap_month");
 * int iMonth     = GetCalendarMonth();
 *
 * if(iMonth != iCombXPMon)
 * {
 * 	SetPersistentInt(oPC,"XP_Combat_cap_month",iMonth);
 * 	iCombXPCap = 0;
 * }
 *
 * if(iCombXP >= C_COMBAT_XP_MAX)
 * {
 * 	SendMessageToPC(oPC,"Durch Kaempfen koennt Ihr nun wirklich nichts mehr lernen.");
 * 	return;
 * }
 *
 * if(iCombXPCap > GetTimedXPCap(oPC))
 * {
 * 	SendMessageToPC(oPC,"Ihr muesstet ueber die gemachten Kampferfahrungen erstmal nachdenken.");
 * 	return;
 * }
 *
 *
 * iXP = ModifyXP(oPC,iXP);
 *
 * iXP = FloatToInt(IntToFloat(iXP) * C_COMBAT_XP_SCALE);
 *
 * //Award at least one XP
 * if(iXP > 0)
 * {
 * 	SetPersistentInt(oPC,"XP_Combat_cap_num",iCombXPCap+iXP);
 * 	SendMessageToPC(oPC, "CombatEP/Month:"+ IntToString(iCombXPCap+iXP) +" / CombatEP:"+ IntToString(iCombXP + iXP));
 * 	SetPersistentInt(oPC,"XP_Combat",iCombXP + iXP);
 * 	GiveXPToCreature(oPC,iXP);
 * }
 * }*/

/*void XP_RewardCombatXPToParty(object oPC, int iXP)
 * {
 * object oArea = GetArea(oPC);
 * int iPartyMembers = 0;
 * int iPartyLevelSum = 0;
 * int iMaxLvlOver;
 *
 * object oChar = GetFirstFactionMember(oPC,TRUE);
 * while(GetIsObjectValid(oChar))
 * {
 * 	if(!GetIsDM(oChar) && GetArea(oChar) == oArea)
 * 	 {
 * 	  iPartyMembers++;
 * 	  iPartyLevelSum += GetHitDice(oChar) + SR_GetECL(oChar);
 * 	 }
 * 	oChar = GetNextFactionMember(oPC,TRUE);
 * }
 *
 * //Killed either by DM or NPC, no 'real' party. Sorry, no XP.
 * if(!iPartyMembers) return;
 *
 * iMaxLvlOver = iPartyLevelSum / iPartyMembers + C_MAX_LEVEL_DIFFERENCE;
 *
 * oChar = GetFirstFactionMember(oPC,TRUE);
 * while(GetIsObjectValid(oChar))
 * {
 * 	if(!GetIsDM(oChar) && GetArea(oChar) == oArea)
 * 	 {
 * 	  int iLevel4XP, iModXP;
 *
 * 	  iLevel4XP = GetHitDice(oChar) + SR_GetECL(oChar);
 * 	  if(iLevel4XP > iMaxLvlOver)
 * 		iLevel4XP = iMaxLvlOver;
 *
 * 	  iModXP = FloatToInt(IntToFloat(iXP) * IntToFloat(iLevel4XP) /
 * 		IntToFloat(iPartyLevelSum));
 * 	  XP_RewardCombatXP(oChar,iModXP);
 * 	 }
 * 	oChar = GetNextFactionMember(oPC,TRUE);
 * }
 * }*/

// Get how much experience the CR is worth to a character of the average level.
//
/*int XP_GetXPFromCR( float a_fCR, float a_fAvgLvl )
 * {
 *
 * 	if(a_fAvgLvl < 3.0) a_fAvgLvl = 3.0;
 *
 * 	// Base experience to build the experience from.
 * 	float fXP = 300.0;
 *
 * 	if( ( a_fAvgLvl >= 7.0 ) || ( a_fCR >= 1.5 ) )
 * 	{
 *
 * 		fXP *= a_fAvgLvl;
 *
 * 		int nDiff = FloatToInt( ( ( a_fCR < 1.0 ) ? 1.0 : a_fCR ) - a_fAvgLvl );
 *
 * 		switch( nDiff )
 * 		{
 *
 * 			// SEI_NOTE: Broken with styleguide for readability.
 *
 * 			case -7:    fXP /= 12.0;        break;
 * 			case -6:    fXP /= 8.0;         break;
 * 			case -5:    fXP *= 3.0 / 16.0;  break;
 * 			case -4:    fXP /= 4.0;         break;
 * 			case -3:    fXP /= 3.0;         break;
 * 			case -2:    fXP /= 2.0;         break;
 * 			case -1:    fXP *= 2.0 / 3.0;   break;
 * 			case  0:                        break;
 * 			case  1:    fXP *= 3.0 / 2.0;   break;
 * 			case  2:    fXP *= 2.0;         break;
 * 			case  3:    fXP *= 3.0;         break;
 *
 * 			// Rikan: Reduced rise in XP when taking a bit over the top
 * 			case  4:    fXP *= 3.5;         break;
 * 			case  5:    fXP *= 4.0;         break;
 * 			case  6:    fXP *= 4.5;         break;
 * 			case  7:    fXP *= 5.0;         break;
 * /*
 * 			case  4:    fXP *= 4.0;         break;
 * 			case  5:    fXP *= 6.0;         break;
 * 			case  6:    fXP *= 8.0;         break;
 * 			case  7:    fXP *= 12.0;        break;
 */
// nDiff > 7 || nDiff < -7
/*            default:    fXP = 0.0;          break;
 *
 * 		} // End switch-case
 *
 * 	} // End if
 *
 * 	// Calculations for CR < 1
 * 	if( ( a_fCR < 0.76 ) && ( fXP > 0.0 ) )
 * 	{
 *
 * 		// SEI_NOTE: Broken with styleguide for readability.
 *
 * 			 if( a_fCR <= 0.11 ) { fXP /= 10.0; }
 * 		else if( a_fCR <= 0.13 ) { fXP /=  8.0; }
 * 		else if( a_fCR <= 0.18 ) { fXP /=  6.0; }
 * 		else if( a_fCR <= 0.28 ) { fXP /=  4.0; }
 * 		else if( a_fCR <= 0.40 ) { fXP /=  3.0; }
 * 		else if( a_fCR <= 0.76 ) { fXP /=  2.0; }
 *
 * 		// Only the CR vs Avg Level table could set nMonsterXP to 0...
 * 		// to fix any round downs that result in 0:
 * 		if( fXP <= 0.0 )
 * 		{
 * 			fXP = 1.0;
 * 		}
 *
 * 	} // End if
 *
 * 	return FloatToInt( fXP );
 *
 * } */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     // End XP_GetXPFromCR

/*void XP_RewardKillXP()
 * {
 * object oPC = GetLastKiller();
 * object oArea = GetArea(OBJECT_SELF);
 * int iPartyMembers = 0;
 * int iPartyLevelSum = 0;
 * int iTotalXP;
 * object oChar = GetFirstFactionMember(oPC,TRUE);
 *
 * while(GetIsObjectValid(oChar))
 * {
 * 	if(!GetIsDM(oChar) && GetArea(oChar) == oArea)
 * 	 {
 * 	  iPartyMembers++;
 * 	  iPartyLevelSum += GetHitDice(oChar) + SR_GetECL(oChar);
 * 	 }
 * 	oChar = GetNextFactionMember(oPC,TRUE);
 * }
 *
 * if(!iPartyMembers) return;
 *
 * iTotalXP = XP_GetXPFromCR(GetChallengeRating(OBJECT_SELF),
 * 	IntToFloat(iPartyLevelSum) / IntToFloat(iPartyMembers));
 *
 * XP_RewardCombatXPToParty(oPC,iTotalXP);
 * }*/

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


int GetTimeXPCap() {
	return C_TIME_XP_1;
}

void GiveTimeXP(object oPC, int nAmount) {
	if ( GetIsDM(oPC) )
		return;

	int iMonth = GetCalendarMonth();
	int iYear = GetCalendarYear();
	int iXPForMonth = GetTimeXPForMonth(oPC, iYear, iMonth);

	if ( iXPForMonth > GetTimeXPCap() ) {
		return;
	}

	if ( nAmount > 0 ) {
		GiveXPToCreature(oPC, nAmount);
		SetTimeXPForMonth(oPC, iXPForMonth + nAmount, iYear, iMonth);
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
