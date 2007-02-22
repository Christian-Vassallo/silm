#include "_gen"
#include "inc_cdb"

#include "x2_inc_spellhook"




void EndAlarm(object oCaster, object oTrap);

void main() {
	if ( !X2PreSpellCastCode() )
		return;

	object oPC = OBJECT_SELF;

	location lTarget = GetSpellTargetLocation();

	int nLevel = GetCasterLevel(oPC);
	int nDC = GetSpellSaveDC();

	float fSize = 10.0;

	int nHours = 2 * nLevel;

	object oTrap = CreateObject(OBJECT_TYPE_PLACEABLE, "trap_alarm", lTarget, FALSE, "trap_alarm");

	SetLocalObject(oTrap, "alarm_caster", oPC);
	SetLocalInt(oTrap, "alarm_caster_cid", GetCharacterID(oPC));
	SetLocalInt(oTrap, "alarm_caster_dc", nDC);

	ApplyEffectAtLocation(DTI, EffectVisualEffect(VFX_IMP_KNOCK), lTarget);

	AssignCommand(oTrap, DelayCommand(HoursToSeconds(nHours), EndAlarm(oPC, oTrap)));
	effect eI = EffectSkillIncrease(SKILL_LISTEN, 1);
	effect eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_LISTEN, 1), eI);
	ApplyEffectToObject(DTT, eLink, oPC, HoursToSeconds(nHours));
	SetupReminder(oPC, GetSpellName(GetSpellId()), HoursToSeconds(nHours), eLink);
}


void EndAlarm(object oCaster, object oTrap) {
	string sLoc = GetName(GetArea(oTrap));
	SendMessageToPC(oCaster, "Der arkane Alarm (" + sLoc + ") endet.");
	DestroyObject(oTrap);
}
