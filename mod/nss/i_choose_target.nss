#include "inc_events"
#include "inc_target"
#include "inc_chat"
#include "inc_cdb"


void main() {
	if ( GetEvent() != EVENT_ITEM_ACTIVATE )
		return;


	object oSelf = GetItemActivated();
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();

	if ( !CheckMask(oPC, AMASK_GM) && !CheckMask(oPC, AMASK_FORCETALK) ) {
		SendMessageToPC(oPC, "Ich mag dich nicht.  PAFF!");
		DestroyObject(oSelf);
		return;
	}

	int nSlot = TARGET_DEFAULT_SLOT;
	if ( GetName(oSelf) == "Zielwahl: 1" )
		nSlot = 1;
	if ( GetName(oSelf) == "Zielwahl: 2" )
		nSlot = 2;
	if ( GetName(oSelf) == "Zielwahl: 3" )
		nSlot = 3;
	if ( GetName(oSelf) == "Zielwahl: 4" )
		nSlot = 4;
	if ( GetName(oSelf) == "Zielwahl: 5" )
		nSlot = 5;
	if ( GetName(oSelf) == "Zielwahl: 6" )
		nSlot = 6;
	if ( GetName(oSelf) == "Zielwahl: 7" )
		nSlot = 7;
	if ( GetName(oSelf) == "Zielwahl: 8" )
		nSlot = 8;
	if ( GetName(oSelf) == "Zielwahl: 9" )
		nSlot = 9;
	if ( GetName(oSelf) == "Zielwahl: 10" )
		nSlot = 10;

	if ( GetIsObjectValid(oTarget) ) {
		SetTarget(oTarget, nSlot, oPC);
	} else {
		SetTargetLocation(lTarget, nSlot, oPC);
	}
}

