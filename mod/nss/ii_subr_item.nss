#include "inc_subr_item"
#include "inc_nwnx_events"

// int ActivateSubraceItem(object oPC, object oItem, location lTarget, object oTarget)



void main() {
    object oPC = OBJECT_SELF;
	object oItem = GetEventItem();
	object oTarget = GetActionTarget();
	vector vTarget = GetEventPosition();
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));

	ActivateSubraceItem(oPC, oItem, lTarget, oTarget);
}
