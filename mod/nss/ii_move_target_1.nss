#include "inc_target"
#include "inc_amask"
#include "inc_nwnx_events"

void main() {

	object oPC = OBJECT_SELF;
	object oItem = GetEventItem();
	object oTarget = GetActionTarget();
	vector vTarget = GetEventPosition();
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));


	if ( !amask(oPC, AMASK_GM) &&
		!amask(oPC, AMASK_FORCETALK) &&
		!amask(oPC, AMASK_GLOBAL_FORCETALK)
	) {
		SendMessageToPC(oPC, "Ich mag dich nicht.  PAFF!");
		DestroyObject(oItem);
		return;
	}


	object oCurrentTarget = GetLocalObject(oItem, "current_target");
	int nRun = GetLocalInt(oItem, "current_target_run") == 1;

	if (GetIsObjectValid(oTarget)) {
		if (!GetIsCreature(oTarget)) {
			SendMessageToPC(oPC, "Not a valid target.");
		} else {
			if (GetIsPC(oTarget)) {
				// make him follow

				if (GetIsObjectValid(oCurrentTarget)) {
					AssignCommand(oCurrentTarget, ClearAllActions(TRUE));
					AssignCommand(oCurrentTarget, ActionForceFollowObject(oTarget));
				} else {
					SendMessageToPC(oPC, "Current target cannot follow PC.");
				}
			} else {
				if (oTarget == oCurrentTarget) {
					nRun = !nRun;
					SetLocalInt(oItem, "current_target_run", nRun);
					if (nRun)
						SendMessageToPC(oPC, "Target runs.");
					else
						SendMessageToPC(oPC, "Target walks.");
				} else {
					ShowTargetFor(-1, oTarget, oPC);
					SetLocalObject(oItem, "current_target", oTarget);
					SetLocalInt(oItem, "current_target_run", 0);
				}
			}
		}
	} else {
		if (GetIsObjectValid(oCurrentTarget)) {
			AssignCommand(oCurrentTarget, ClearAllActions(TRUE));
			AssignCommand(oCurrentTarget, ActionMoveToLocation(lTarget, nRun));
		} else {
			SendMessageToPC(oPC, "No valid target for this item is set.");
		}

	}
}
