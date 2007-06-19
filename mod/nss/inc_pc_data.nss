#include "inc_cdb"
#include "inc_xp_handling"
#include "inc_mysql"
//#include "_map"
#include "_gen"

void load_donequests(object oPC) {
	int iQS;

	//Archer prestige class
	/*if(GetLegPersistentInt(oPC,"PX1_AllowArcher"))
	 * {
	 * SetLocalInt(oPC,"X1_AllowArcher",0);
	 * AddJournalQuestEntry("p000",999,oPC,FALSE);
	 * } else
	 * SetLocalInt(oPC,"X1_AllowArcher",1);
	 */

}

/*
 * NB: Variables which are saved during character export MUST
 * be DeleteLocalInt()'ed during load because SetLocalInt doesn't
 * work during save, dirtying the cache.
 */

void save_spelllist(object oPC) {
	int nSpell;
	int iNoOfSpells;
	for ( nSpell = 0; nSpell < 800; nSpell++ ) {
		int iMemorized;
		if ( ( iMemorized = GetHasSpell(nSpell, oPC) ) > 0 ) {
			SetLegacyPersistentInt(oPC, "Spell_num_" + IntToString(iNoOfSpells), nSpell, 1);
			SetLegacyPersistentInt(oPC, "Spell_mem_" + IntToString(iNoOfSpells++), iMemorized, 1);
		}
	}
	SetLegacyPersistentInt(oPC, "Spell_count", iNoOfSpells, 1);
}

void load_spelllist(object oPC) {
	int nSpell;
	int iNoOfSpells;
	int i, j, iMemorized, iCurrent;

	DeleteLocalInt(oPC, "PER_Spell_count");

	iNoOfSpells = GetLegacyPersistentInt(oPC, "Spell_count");

	for ( i = 0; i < 800; i++ ) DeleteLocalInt(oPC, "Spell_" + IntToString(i));
	for ( i = 0; i < iNoOfSpells; i++ ) {
		DeleteLocalInt(oPC, "PER_Spell_num_" + IntToString(i));
		DeleteLocalInt(oPC, "PER_Spell_mem_" + IntToString(i));
		nSpell = GetLegacyPersistentInt(oPC, "Spell_num_" + IntToString(i));
		iMemorized = GetLegacyPersistentInt(oPC, "Spell_mem_" + IntToString(i));
		SetLocalInt(oPC, "Spell_" + IntToString(nSpell), iMemorized);
	}
	for ( i = 0; i < 800; i++ ) {
		iCurrent = GetHasSpell(i, oPC);
		iMemorized = GetLocalInt(oPC, "Spell_" + IntToString(i));

		if ( iCurrent > iMemorized ) {
			for ( j = iMemorized; j < iCurrent; j++ )
				DecrementRemainingSpellUses(oPC, i);
		}
	}
}

void restore_lp(object oPC, int iCurrentLP) {
	if ( iCurrentLP > -900 && !GetLocalInt(oPC, "IS_DEAD") && !GetIsDead(oPC) ) {
		int iDiff = GetCurrentHitPoints(oPC) - iCurrentLP;
		if ( iDiff > 0 )
			ApplyEffectToObject(DURATION_TYPE_INSTANT,
				EffectDamage(iDiff, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE), oPC);
		else if ( iDiff < 0 )
			ApplyEffectToObject(DURATION_TYPE_INSTANT,
				EffectHeal(-iDiff), oPC);
	}
}


void save_player(object oPC, int autosave = FALSE) {
	if ( !GetIsPC(oPC) || GetIsDM(oPC) )
		return;

	SetLegacyPersistentInt(oPC, "Current_LP", GetCurrentHitPoints(oPC) + 1000, 1);
	save_spelllist(oPC);

	// SaveMapPinsForPlayer(oPC);

	// save Location
	/*if ( GetLocalInt(GetArea(oPC), "no_save") != 1 ) {
		string sCharName = SQLEncodeSpecialChars(GetName(oPC));
		string sPlayerName = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
		vector vPosition = GetPosition(oPC);
		string sAreaTag = GetTag(GetArea(oPC));
		string sSQL = "UPDATE tab_chars SET AreaTag='" +
					  sAreaTag +
					  "', X= " +
					  FloatToString(vPosition.x) +
					  ", Y= " +
					  FloatToString(vPosition.y) +
					  ", Z= " +
					  FloatToString(vPosition.z) +
					  ", Richtung= " +
					  FloatToString(GetFacing(oPC)) +
					  "  WHERE Char_Name='" + sCharName + "' AND GSA_Account='" + sPlayerName + "';";
		SQLExecDirect(sSQL);
		//SendMessageToPC(oPC, "Location saved: "+ sSQL);
	}*/

	/* DONT save polymorphed characters. That re-applies the polymorph effect
	 * and thus the visuals, and re-sets the TP to Max + 10 */
	int iPolymorphed = GetIsPolymorphed(oPC);
	if ( !iPolymorphed ) {
		ExportSingleCharacter(oPC);
		SaveCharacter(oPC, 0);
	}

	if ( autosave == TRUE )
		DelayCommand(100.0, save_player(oPC, autosave));
}

void load_player(object oPC) {
	if ( !GetIsPC(oPC) || GetIsDM(oPC) )
		return;

	DeleteLocalInt(oPC, "PER_XP_Combat");
	DeleteLocalInt(oPC, "PER_Current_LP");
	DeleteLocalInt(oPC, "PER_XP_Combat_cap_num");
	DeleteLocalInt(oPC, "PER_XP_Combat_cap_month");

	int iCurrentLP     = GetLegacyPersistentInt(oPC, "Current_LP") - 1000;

	DelayCommand(1.0f, load_spelllist(oPC));
	if ( iCurrentLP < 0 && iCurrentLP > -900 ) {
		WriteTimestampedLogEntry(GetName(oPC) + ": Login with " +
			IntToString(iCurrentLP) + " LP!");
		iCurrentLP = 1;
		XP_LoseXP(oPC, GetXP(oPC) / 10, TRUE, TRUE);
	}
	DelayCommand(( ( iCurrentLP > 0 ) ? 1.2f : 7.0f ), restore_lp(oPC, iCurrentLP));

	load_donequests(oPC);

	//Allow summoning of animal companion or familiar for the cases the creature
	//was gone because of logout or crash
	IncrementRemainingFeatUses(oPC, FEAT_ANIMAL_COMPANION);
	IncrementRemainingFeatUses(oPC, FEAT_SUMMON_FAMILIAR);
}

