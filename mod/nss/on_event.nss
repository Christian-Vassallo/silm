#include "inc_nwnx_events"

void main() {
/*    int nEventType = GetEventType();
    
	WriteTimestampedLogEntry("NWNX Event fired: "+IntToString(nEventType)+", '"+GetName(OBJECT_SELF)+"'");

    object oPC, oTarget, oItem;
    switch(nEventType) {
        case EVENT_PICKPOCKET:
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
            WriteTimestampedLogEntry(GetName(oPC)+" tried to steal from "+GetName(oTarget));
            FloatingTextStringOnCreature("You're trying to steal from "+GetName(oTarget), oPC, FALSE);
            break;

        case EVENT_ATTACK:
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
            WriteTimestampedLogEntry(GetName(oPC)+" attacked "+GetName(oTarget));
            FloatingTextStringOnCreature("Attacking "+GetName(oTarget), oPC, FALSE);
            break;

        case EVENT_USE_ITEM:
            oPC = OBJECT_SELF;
            oTarget = GetActionTarget();
            oItem = GetEventItem();
            vector vTarget = GetEventPosition();
            WriteTimestampedLogEntry(GetName(oPC)+" used item '"+GetName(oItem)+"' on "+GetName(oTarget));
            FloatingTextStringOnCreature("Using item '"+GetName(oItem)+"' on "+GetName(oTarget), oPC, FALSE);
            SendMessageToPC(oPC, "Location: "+FloatToString(vTarget.x)+"/"+FloatToString(vTarget.y)+"/"+FloatToString(vTarget.z));
            if(d2()==1) {
                BypassEvent();
                WriteTimestampedLogEntry("The action was cancelled");
                FloatingTextStringOnCreature("The action was cancelled", oPC, FALSE);
            }
            break;
    }*/
}
