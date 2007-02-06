#include "inc_cs_dispenser"

void main() {
	object oPC = GetLastUsedBy();
	object oThis = OBJECT_SELF;

	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0f, 2.0f));
	AssignCommand(oPC, ActionDoCommand(
			Action_UseDispenser(oPC, oThis)));
}

