#include "_gen"
#include "inc_events"
#include "inc_chat_run"


void main() {
	if ( GetEvent() != EVENT_ITEM_ACTIVATE )
		return;

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();

	object oTarget = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();

	if ( GetIsObjectValid(oTarget) )
		lTarget = GetLocation(oTarget);


	string sMacro = GetLocalString(oItem, "macro");

	if ( "" == sMacro ) {
		ToPC("This item has no macro set.", oPC);
		return;
	}

	ToPC("Executing macro '" + sMacro + "' ..", oPC);


	int nOldTarget = GetDefaultSlot(oPC);

	SetDefaultSlot(TARGET_MACRO_SLOT, oPC);

	ToPC("Targeting ..", oPC);

	SetTarget(oTarget, TARGET_MACRO_SLOT, oPC);
	SetTargetLocation(lTarget, TARGET_MACRO_SLOT, oPC);

	ToPC("Targeting done ..", oPC);

	CommandEval(oPC, MODE_TALK, sMacro, FALSE);

	SetDefaultSlot(nOldTarget, oPC);

	ToPC("Macro code done.", oPC);

}
