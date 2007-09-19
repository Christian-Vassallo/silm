#include "corpse_raise"

int StartingConditional() {
	int iPrice;

	if ( GetLocalInt(OBJECT_SELF, "NO_STORE") ) return FALSE;

	return TRUE;
}
