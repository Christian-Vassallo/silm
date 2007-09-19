void ActionAutoClose(int nDelay = 60);


void ActionAutoCloseLock(int nDelay = 60);


//

void ActionAutoClose(int nDelay = 60) {
	ActionWait(IntToFloat(nDelay));
	ActionCloseDoor(OBJECT_SELF);
}


void ActionAutoCloseLock(int nDelay = 60) {
	ActionAutoClose(nDelay);
	ActionDoCommand(SetLocked(OBJECT_SELF, 1));
}
