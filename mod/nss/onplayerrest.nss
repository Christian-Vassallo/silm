#include "inc_resting"

void main() {
	object oPC = GetLastPCRested();
	int iEvent = GetLastRestEventType();

	// Said to bypass the procedure
	if ( GetLocalInt(oPC, "Resting_State") ) {
		DeleteLocalInt(oPC, "Resting_State");
		return;
	}

	if ( iEvent == REST_EVENTTYPE_REST_FINISHED ) {
		FinishedResting(oPC);
		return;
	}

	if ( iEvent == REST_EVENTTYPE_REST_CANCELLED ) {
		CancelledResting(oPC);
		return;
	}

	//Scripted resting bypasses this, so this means button pressed.
	if ( iEvent == REST_EVENTTYPE_REST_STARTED ) {
		CancelResting(oPC);
		AssignCommand(oPC, ActionStartConversation(oPC, "resting_dlg", TRUE, FALSE));
		return;
	}
}

