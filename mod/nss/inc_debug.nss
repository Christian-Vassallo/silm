#include "_colours"

/**
 * Sends a dbg message to the relevant
 * authorities.
 */
void dbg(string sMessage, int nLevel = 1, object oTarget = OBJECT_INVALID);


void dbg(string sMessage, int nLevel = 1, object oTarget = OBJECT_INVALID) {
	
	string sMsg2 = "(dbg:" + IntToString(nLevel);
	if (GetIsObjectValid(oTarget))
		sMsg2 += ":" + GetResRef(oTarget) + ":" + GetTag(oTarget) + GetName(oTarget);
	sMsg2 += ") " + sMessage;
	sMessage = sMsg2;

	if (GetLocalInt(GetModule(), "dbg") >= nLevel) {
		WriteTimestampedLogEntry(sMessage);
		SendMessageToAllDMs(sMessage);
	}

	
}
