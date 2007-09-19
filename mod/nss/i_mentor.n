#include "_gen"
#include "inc_events"
#include "inc_cdb"
#include "inc_ms"

void main() {


	if ( GetEvent() != EVENT_ITEM_ACTIVATE )
		return;

	object
	oItem = GetItemActivated(),
	oPC = GetItemActivator(),
	oTarget = GetItemActivatedTarget();

	if ( GetIsInCombat(oPC) || GetIsInCombat(oTarget) ) {
		FloatingTextStringOnCreature("Das wird nix waehrend Gegner in der Naehe sind.", oPC, 0);
		return;
	}


	if ( !GetIsPC(oTarget) ) {
		FloatingTextStringOnCreature("Du musst auf einen Spieler - oder dich selbst - zielen.", oPC, 0);
		return;
	}

	SetLocalObject(oPC, "mentor_target", oTarget);

	MS_Start(oPC, oItem);
}
