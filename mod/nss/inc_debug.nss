#include "_colours"

/**
 * Sends a dbg message to the relevant
 * authorities.
 */
void dbg(string sMessage, int nLevel = 1, object oTarget = OBJECT_INVALID);


void dbg(string sMessage, int nLevel = 1, object oTarget = OBJECT_INVALID) {
	
	sMessage = "(dbg:" + IntToString(nLevel);
	if (GetIsObjectValid(oTarget))
		sMessage += ":" + GetResRef(oTarget) + ":" + GetTag(oTarget) + GetName(oTarget);
	sMessage += ") " + sMessage;

	if (GetLocalInt(GetModule(), "dbg") >= nLevel) {
		WriteTimestampedLogEntry(sMessage);
		SendMessageToAllDMs(sMessage);
	}

	
}
