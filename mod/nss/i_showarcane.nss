#include "_gen"
#include "_events"

void main() {
	if ( EVENT_ITEM_ACTIVATE != GetEvent() )
		return;

	object
	oItem = GetItemActivated(),
	oPC = GetItemActivator(),
	oTarget = GetItemActivatedTarget();

	if ( !GetIsCreature(oTarget) )
		return;

	SendMessageToPC(oPC, "Active spells on " + GetName(oTarget) + ":");


	int nSpellID = -1;
	string sSpellName = "";

	string sAllSpells = " ";

	effect e = GetFirstEffect(oPC);
	while ( GetIsEffectValid(e) ) {
		if ( GetEffectType(e) != EFFECT_TYPE_VISUALEFFECT ) {
			nSpellID = GetEffectSpellId(e);

			if ( nSpellID != -1 && - 1 == FindSubString(sAllSpells, IntToString(nSpellID)) ) {
				sSpellName = GetSpellName(nSpellID);
				sAllSpells += IntToString(nSpellID) + " ";
				SendMessageToPC(oPC, sSpellName);
			}
		}
		e = GetNextEffect(oPC);
	}

	SendMessageToPC(oPC, "End of list.");
}
