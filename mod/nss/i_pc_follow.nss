#include "_gen"
#include "_events"

void main() {
	if ( GetEvent() != EVENT_ITEM_ACTIVATE )
		return;

	object
	oPC = GetItemActivator(),
	oTarget = GetItemActivatedTarget();


	if ( !GetIsCreature(oTarget) )
		return;

	if ( GetIsInCombat(oPC) )
		return;

	if ( oPC == oTarget )
		return;

	AssignCommand(oPC, ActionForceFollowObject(oTarget, 2.0f));
	FloatingTextStringOnCreature("Folge: " + GetName(oTarget), oPC, FALSE);
}
