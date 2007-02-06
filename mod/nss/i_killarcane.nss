#include "_gen"

#include "_events"
#include "inc_killarcane"

void main() {
	if ( EVENT_ITEM_ACTIVATE != GetEvent() )
		return;

	object
	oItem = GetItemActivated(),
	oPC = GetItemActivator(),
	oTarget = GetItemActivatedTarget();

	if ( oTarget != oPC )
		return;



	KillArcane_BuildDialog(oPC);
	AssignCommand(oPC, ActionStartConversation(oPC, "list_select", TRUE, TRUE));
}
