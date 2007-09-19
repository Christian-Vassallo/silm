#include "_gen"
#include "inc_audit"

void main() {
	object oDoor = OBJECT_SELF;
	object oPC = GetLastDamager(oDoor);

	// D
	if ( !GetIsObjectValid(oPC) )
		return;

	string sMsg = "Huah! " +
				  GetTag(oDoor) +
				  " wurde von " + GetName(oPC) + " (Account: " + GetPCPlayerName(oPC) + ") eingeschlagselt.";
	SendMessageToAllDMs(sMsg);

	WriteTimestampedLogEntry(sMsg);

	audit("door_death", oPC, audit_fields("area", GetResRef(GetArea(oPC))), "audit", oDoor);
}
