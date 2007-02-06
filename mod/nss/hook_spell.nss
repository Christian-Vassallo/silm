#include "x2_inc_switches"
#include "_gen"
#include "inc_draw"
#include "_events"

#include "inc_planewalk"
#include "inc_craft"
#include "inc_spelltools"


int WildMagic(object oPC);

void WildMagicVisuals(object oPC);

void main() {
	object oPC = OBJECT_SELF;
	location lLoc = GetLocation(oPC);
	int nSpell = GetSpellId(); // returns the SPELL_* constant of the spell cast
	object oTarget = GetSpellTargetObject(); // returns the targeted object of the spell, if valid
	location lTarget = GetSpellTargetLocation(); // returns the targeted location of the spell, if valid
	int nClass = GetLastSpellCastClass(); // gets the class the PC cast the spell as
	object oItem = GetSpellCastItem(); // if an item cast the spell, this function gets that item
	int nDC = GetSpellSaveDC(); // gets the DC required to save against the effects of the spell
	int nLevel = GetCasterLevel(oPC); // gets the level the PC cast the spell as
	int nMeta = GetMetaMagicFeat();



	// Run Wildmagic for areas or PCs designated to do


	int nRunWildMagic = 0;
	if ( GetLocalInt(oPC, "wild_magic") )
		nRunWildMagic = GetLocalInt(oPC, "wild_magic");
	if ( GetLocalInt(GetArea(oPC), "wild_magic") )
		nRunWildMagic = GetLocalInt(GetArea(oPC), "wild_magic");
	if ( GetLocalInt(GetModule(), "wild_magic") )
		nRunWildMagic = GetLocalInt(GetModule(), "wild_magic");
	if ( BASE_ITEM_POTIONS == GetBaseItemType(oItem) )
		nRunWildMagic = 0;

	if ( nRunWildMagic && WildMagic(oPC) )
		return;



	// The Event hook goes here

	if ( GetIsItem(oTarget) ) {
		int nResult = RunEventScript(oTarget, EVENT_ITEM_SPELLCAST_AT, EVENT_PREFIX_ITEM);

		if ( EVENT_EXECUTE_SCRIPT_END == nResult ) {
			// Do not continue.
			SetModuleOverrideSpellScriptFinished();
			SendMessageToAllDMs("Spellhook terminated by Item SpellCastAt-Script: " + GetTag(oTarget));
			return;
		}
	}


	// SpellStaff
	if ( DoSpellStaff(oPC, nSpell) )
		SetModuleOverrideSpellScriptFinished();

	// Craft system

	if ( GetIsPlaceable(oTarget) && GetStringLowerCase(GetStringLeft(GetTag(oTarget), 4)) == "hws_"
		&& OnSpellCastAt(oPC, oTarget, nSpell, nMeta)
	)
		SetModuleOverrideSpellScriptFinished();

}

int WildMagic(object oPC) {
	location lLoc = GetLocation(oPC);
	int nSpell = GetSpellId(); // returns the SPELL_* constant of the spell cast
	object oTarget = GetSpellTargetObject(); // returns the targeted object of the spell, if valid
	location lTarget = GetSpellTargetLocation(); // returns the targeted location of the spell, if valid
	int nClass = GetLastSpellCastClass(); // gets the class the PC cast the spell as
	object oItem = GetSpellCastItem(); // if an item cast the spell, this function gets that item
	// int nDC = GetSpellSaveDC(); // gets the DC required to save against the effects of the spell
	int nLevel = GetCasterLevel(oPC); // gets the level the PC cast the spell as


	int nDC = 12 + d3();

	// Dont run for NPCS or DMS
	if ( !GetIsPC(oPC) || GetIsDM(oPC) )
		return 0;

	// Dont run for Item-Triggered Spells
	if ( GetIsObjectValid(oItem) )
		return 0;

	int bIsImmune = GetIsImmune(oPC, IMMUNITY_TYPE_MIND_SPELLS);

	// Allow to save by concentration?

	int nDam = GetCurrentHitPoints(oPC) - d20();

	// some mean switch here!
	switch ( d6() ) {
		case 1:
		case 2:
			// Works as expected
			if ( WillSave(oPC, nDC - ( bIsImmune * 4 ), SAVING_THROW_TYPE_MIND_SPELLS) )
				return 0;

			// failed, fall thru

		case 3:
		case 4:
			// fails, burps
			if ( bIsImmune || WillSave(oPC, nDC, SAVING_THROW_TYPE_MIND_SPELLS) ) {
				SpeakString("*Die Magieladung verpufft wirkungslos.*");
				SetModuleOverrideSpellScriptFinished();
				return 1;
			}
			// failed, fall thru
		case 5:
		case 6:
			// Well, that DIDNT work out.
			SetModuleOverrideSpellScriptFinished();

			DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam), oPC));
			DrawSpiral(DURATION_TYPE_INSTANT, VFX_IMP_DOMINATE_S, lLoc, 8.0, 0.0, 1.0, 45, 2.5, 3.0);
			DrawSpiral(DURATION_TYPE_INSTANT, VFX_IMP_FROST_S, lLoc, 8.0, 0.0, 1.0, 45, 2.5, 3.0, 180.0);
			DelayCommand(3.0, WildMagicVisuals(oPC));

			// near-lethal damage, unconcious
			switch ( Random(6) ) {
				case 0:
				case 1:
					SpeakString("*Die Magieladung schlaegt auf Euch zurueck, und verwirrt Euren Geist.*");
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConfused(), oPC, 120.0);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, 120.0);
					break;
				case 2:
				case 3:
					SpeakString(
						"*Die Magieladung schlaegt auf Euch zurueck, und laesst Euch - im Geiste - die Ebenen wandern.*");
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConfused(), oPC, 120.0);
					DelayCommand(3.5, PlaneWalk(oPC, "", 120.0));
					break;
			}

			break;
	}

	return 1;
}

void WildMagicVisuals(object oPC) {
	location lLoc = GetLocation(oPC);


	int fx = Random(5);
	fx = fx ==
		 0 ? VFX_BEAM_LIGHTNING : fx ==
		 1 ? VFX_BEAM_EVIL : fx == 2 ? VFX_BEAM_FIRE : fx == 3 ? VFX_BEAM_MIND : VFX_BEAM_ODD;

	float d = 5.5;

	float r = 4.0;

	BeamIcosahedron(DURATION_TYPE_TEMPORARY, fx, lLoc, r, d, "", 5.0);
	BeamTriacontahedron(DURATION_TYPE_TEMPORARY, fx, lLoc, r, d, "", 5.0);
	BeamIcosahedron(DURATION_TYPE_TEMPORARY, fx, lLoc, r, d, "", 5.0);
	BeamTriacontahedron(DURATION_TYPE_TEMPORARY, fx, lLoc, r, d, "", 5.0);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), lLoc);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oPC);
}

