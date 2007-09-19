#include "inc_doors"

void main() {
	object oDoor = OBJECT_SELF;
	object oPC = GetLastClosedBy();

	// ClearAllActions();

//    int nAutoClose = GetLocalInt(oDoor, "autoclose");
	int nAutoLock = GetLocalInt(oDoor, "autolock");

	if ( nAutoLock < 0 || nAutoLock )
		ActionDoCommand(SetLocked(OBJECT_SELF, 1));
	//ActionAutoClose(nAutoClose < 0 ? 60 : nAutoClose);
}
