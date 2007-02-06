#include "corpse_raise"
#include "inc_currency"

void _ResurrectResult(object oWho) {
	/*
	 * The corpse object would be destructed if the resurrection is successful
	 */
	if ( GetIsObjectValid(oWho) )
		SpeakString("Wie es aussieht scheint " + GetDeity(OBJECT_SELF) + " nicht willens zu sein zu helfen.");
	else
		SpeakString("Seht die Macht von " + GetDeity(OBJECT_SELF) + ", die selbst den Tod besiegt!");
}

void _TryResurrect(object oWho) {
	ActionCastSpellAtObject(SPELL_RESURRECTION, oWho, METAMAGIC_NONE, TRUE);
	ActionDoCommand(DelayCommand(1.0f, _ResurrectResult(oWho)));
}

void main() {
	object oCorpse;
	if ( !GetIsObjectValid(oCorpse = GetLocalObject(OBJECT_SELF, "CURRENT_CORPSE")) ) return;

	TakeValueFromCreature(GetLocalInt(OBJECT_SELF, "CURRENT_PRICE"), GetPCSpeaker());
	DelayCommand(0.2f, _TryResurrect(oCorpse));
}
