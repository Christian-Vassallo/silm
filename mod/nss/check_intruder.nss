void main() {
	object oPC = GetEnteringObject();
	int nEindringling = GetLocalInt(oPC, "Eindringling");
	object oDoor1 = GetObjectByTag("SEC_DOORLOCK1");
	object oDoor2 = GetObjectByTag("SEC_DOORLOCK2");
	object oHebel = GetObjectByTag("SEC_HEBEL");
	if ( nEindringling == TRUE ) {
		ActionDoCommand(ActionCloseDoor(oDoor1));
		SetLocked(oDoor1, TRUE);
		ActionDoCommand(ActionCloseDoor(oDoor2));
		SetLocked(oDoor2, TRUE);
	}
}
