#include "inc_target"
#include "inc_amask"
#include "inc_nwnx_events"
#include "inc_objset"

void main() {
	
	object oPC = OBJECT_SELF;
	object oItem = GetEventItem();
	object oTarget = GetActionTarget();
	vector vTarget = GetEventPosition();
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));
	int i;

	if ( !amask(oPC, AMASK_GM) &&
		!amask(oPC, AMASK_FORCETALK) &&
		!amask(oPC, AMASK_GLOBAL_FORCETALK)
	) {
		SendMessageToPC(oPC, "Ich mag dich nicht.  PAFF!");
		DestroyObject(oItem);
		return;
	}

	string sSetName = GetLocalString(oItem, "objset_name");
	if ("" == sSetName) {
		SendMessageToPC(oPC, "No set name on this item.");
		return;
	}

	int nRun = GetLocalInt(oItem, "current_target_run") == 1;
	int nQueues = GetLocalInt(oItem, "current_target_queues") == 1;

	if (GetIsObjectValid(oTarget)) {
		if (!GetIsCreature(oTarget)) {
			
			if (oTarget == oItem) {
				// toggle queueing
				nQueues = !nQueues;
				SetLocalInt(oItem, "current_target_queues", nQueues);
				if (nRun)
					SendMessageToPC(oPC, "Target queues actions.");
				else
					SendMessageToPC(oPC, "Target does not queue actions.");

			} else {
				SendMessageToPC(oPC, "Not a valid target.");
			}
			
		} else {
			if (!GetIsInSet(sSetName, oTarget, oPC)) {
				// make the whole set walk
				object o;
				for (i = 0; i < GetSetSize(sSetName, oPC); i++) {
					o = GetFromSet(sSetName, i, oPC);
					if (!nQueues)
						AssignCommand(o, ClearAllActions(TRUE));
					AssignCommand(o, ActionForceFollowObject(oTarget, 2.0f));
				}
			} else {
				// toggle run/walk
				nRun = !nRun;
				SetLocalInt(oItem, "current_target_run", nRun);
				if (nRun)
					SendMessageToPC(oPC, "Target runs.");
				else
					SendMessageToPC(oPC, "Target walks.");
			}
		}
	} else {
		object o;
		for (i = 0; i < GetSetSize(sSetName, oPC); i++) {
			o = GetFromSet(sSetName, i, oPC);
			if (!nQueues)
				AssignCommand(o, ClearAllActions(TRUE));
			AssignCommand(o, ActionMoveToLocation(lTarget, nRun));
		}
	}
}
