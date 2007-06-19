#include "inc_lastlocation"

void main() {
	object oPC = GetLastUsedBy();

	location l = GetLastLocationOnLogout(oPC);
	AssignCommand(oPC, ActionJumpToLocation(l));
}
