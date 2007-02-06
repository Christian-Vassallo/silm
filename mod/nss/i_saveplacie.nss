#include "_events"
#include "_target"
#include "_chat"
#include "_gen"

#include "inc_dbplac"

void main() {
	if ( GetEvent() != EVENT_ITEM_ACTIVATE )
		return;


	object oSelf = GetItemActivated();
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();

	if ( !CheckMask(oPC, AMASK_BACKEND) ) {
		SendMessageToPC(oPC, "Ich mag dich nicht.  PAFF!");
		DestroyObject(oSelf);
		return;
	}

	if ( !GetIsPlaceable(oTarget) ) {
		SendMessageToPC(oPC, "Das ist kein Placie.");
		return;
	}

	int n = SavePlacie(oTarget);
	switch ( n ) {
		case SAVE_ERROR:
			SendMessageToPC(oPC, "Fehler beim Speichern.");
			break;
		case SAVE_NEW:
			SendMessageToPC(oPC, "Placie neu in DB, id: " + IntToString(GetLocalInt(oTarget, "placie_id")));
			break;
		case SAVE_UPDATE:
			SendMessageToPC(oPC, "Placie updated, id: " + IntToString(GetLocalInt(oTarget, "placie_id")));
			break;
	}
}

