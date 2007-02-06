int _GetAlignMask(string sAlign) {
	if ( sAlign == "LG" ) return 0x0400;
	else if ( sAlign == "LN" ) return 0x0200;
	else if ( sAlign == "LE" ) return 0x0100;
	else if ( sAlign == "NG" ) return 0x0040;
	else if ( sAlign == "N" ) return 0x0020;
	else if ( sAlign == "NE" ) return 0x0010;
	else if ( sAlign == "CG" ) return 0x0004;
	else if ( sAlign == "CN" ) return 0x0002;
	else if ( sAlign == "CE" ) return 0x0001;

	// Now some meta tags for groups of alignments (all lawful, all good, and so on)
	else if ( sAlign == "L*" ) return 0x0700;
	else if ( sAlign == "N*" ) return 0x0070;
	else if ( sAlign == "C*" ) return 0x0007;
	else if ( sAlign == "*G" ) return 0x0444;
	else if ( sAlign == "*N" ) return 0x0222;
	else if ( sAlign == "*E" ) return 0x0111;
	else if ( sAlign == "**" ) return 0x0777;

	return 0;
}

int GetAlignMask(string sAlignList) {
	int nEnd;
	int iMask;
	string sAlign;

	while ( ( nEnd = FindSubString(sAlignList, ",") ) >= 0 ) {
		sAlign = GetSubString(sAlignList, 0, nEnd);
		iMask |= _GetAlignMask(sAlign);
		sAlignList = GetSubString(sAlignList, nEnd + 1, 99);
	}
	/* After the last comma or only entry in line */
	sAlign = sAlignList;
	iMask |= _GetAlignMask(sAlign);
	return iMask;
}

void SetGodAlignments(string sGod, string sAlign) {
	SetLocalString(GetModule(), "GOD_AL_" + sGod, sAlign);
}

string GetGodAlignments(string sGod) {
	return GetLocalString(GetModule(), "GOD_AL_" + sGod);
}

int GetPCAlignMask(object oPC) {
	int iValue;
	int iAl1, iAl2;

	iAl1 = GetAlignmentGoodEvil(oPC);
	if ( iAl1 == ALIGNMENT_GOOD ) iValue = 4;
	else if ( iAl1 == ALIGNMENT_NEUTRAL ) iValue = 2;
	else if ( iAl1 == ALIGNMENT_EVIL ) iValue = 1;

	iAl2 = GetAlignmentLawChaos(oPC);
	if ( iAl2 == ALIGNMENT_LAWFUL ) iValue *= 0x0100;
	else if ( iAl2 == ALIGNMENT_NEUTRAL ) iValue *= 0x0010;

	return iValue;
}

// Returns nonzero if PC has an alignment the given deity is okay with it.
int MatchPCAgainstGod(object oPC, string sGod) {
	int iGAlMask = GetAlignMask(GetGodAlignments(sGod));
	int iPCAl    = GetPCAlignMask(oPC);

	return iGAlMask & iPCAl;
}

/*
 * Check wether a resurrection made by oCaster on oTarget would work
 * If not, and "Silently" is not set, apply a boo-boo effect
 */
int Check_Resurrect(object oCaster, object oTarget, int iSilently = FALSE) {
	if ( !GetIsObjectValid(oTarget) ) return FALSE;

	if ( GetIsDM(oCaster) ) return TRUE;

	//Relaxation 1: Works everytime when the caster is a PC
//  if(GetIsPC(oCaster)) return TRUE;

	//Relaxation 2: Works everytime when the target is a NPC
//  if(!GetIsPC(oTarget)) return TRUE;

	if ( MatchPCAgainstGod(oTarget, GetDeity(oCaster)) > 0 ) return TRUE;

	if ( !iSilently )
		ApplyEffectToObject(DURATION_TYPE_INSTANT,
			EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oCaster);
	return FALSE;
}

/*
 * Check wether the caster is able to perform a resurrect
 * If not, and "Silently" is not set, apply a boo-boo effect
 */
int CheckResurrectAble(object oCaster, int iSilently = FALSE) {
	//NPCs are supposed to cast the spells.
	if ( !GetIsPC(oCaster) || GetIsDM(oCaster) ) return TRUE;

	//Clerics starting with level 3, druids with 4 and paladins with 5.
	if ( GetLevelByClass(CLASS_TYPE_CLERIC, oCaster)  >= 3 ) return TRUE;

	if ( GetLevelByClass(CLASS_TYPE_DRUID, oCaster)   >= 4 ) return TRUE;

	if ( GetLevelByClass(CLASS_TYPE_PALADIN, oCaster) >= 5 ) return TRUE;

	if ( !iSilently )
		ApplyEffectToObject(DURATION_TYPE_INSTANT,
			EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oCaster);
	return FALSE;
}

