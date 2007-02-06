#include "inc_subr_item"
#include "inc_miscitm"
#include "inc_summon"
#include "_events"
#include "inc_cdb"


void main() {
	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	string sItem = GetTag(oItem);
	object oTarget = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();

	if ( ActivateSubraceItem(oPC, oItem, lTarget, oTarget) )
		return;

	if ( ActivateMiscItem(oPC, oItem, lTarget, oTarget) )
		return;

	if ( ActivateSummonItem(oPC, oItem, lTarget, oTarget) )
		return;

	ExecuteScript("dmfi_activate", oPC);

	if ( sItem == "Laute" || sItem == "Lyra" || sItem == "Tamburin" || sItem == "Panflte" ) {
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BARD_SONG), oPC, 18.0);
	}

	if ( TestStringAgainstPattern("move_**", sItem) ) {
		ExecuteScript("item2plac", oItem);
		return;
	}

	if ( TestStringAgainstPattern("herb**", sItem) ) {
		ExecuteScript("i__herb", oItem);
		return;
	}

	if ( TestStringAgainstPattern("c_**", sItem) ) {
		ExecuteScript("i__craft", oItem);
	}


	// Run the event script, if available.
	RunEventScript(oItem, EVENT_ITEM_ACTIVATE, EVENT_PREFIX_ITEM);
}
