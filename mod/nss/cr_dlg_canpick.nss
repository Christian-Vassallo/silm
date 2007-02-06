#include "inc_corpse"

int StartingConditional() {
	object oBody = GetLocalObject(OBJECT_SELF, "Body");

	if ( GetLocalInt(oBody, "CORPSE_NOT_PORTABLE") ) return 0;

	if ( GetIsObjectValid(GetLocalObject(oBody, "PC_CORPSE")) ) return 1;

	if ( GetLocalInt(oBody, "WAS_PC_CORPSE") ) return 1;

	if ( GetPlotFlag(OBJECT_SELF) ) return 0;

	return 1;
}
