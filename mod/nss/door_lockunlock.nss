void main() {
	object oDoor = OBJECT_SELF;
	object oOther = GetTransitionTarget(oDoor);

	//ClearAllActions();

	/* do not run this script for non-lockabes */
	if (
		!GetIsObjectValid(oDoor)
		|| !GetIsObjectValid(oDoor)
		|| !GetLockLockable(oOther)
		|| !GetLockLockable(oDoor)
	)
		return;

	if ( GetLocalInt(oDoor, "lockdoorlock") ) {
		SetLocalInt(oDoor, "lockdoorlock", 0);
		return;
	}

	SetLocalInt(oOther, "lockdoorlock", 1);
	SetLocked(oOther, GetLocked(oDoor));
}

