// Door heartbeat.

void main() {
	// Only run each odd heartbeat for performance reasons
	if ( !GetLocalInt(OBJECT_SELF, "hb_odd") ) {
		SetLocalInt(OBJECT_SELF, "hb_odd", 1);
		return;
	} else
		SetLocalInt(OBJECT_SELF, "hb_odd", 0);





	int
	nUseLocking = GetLocalInt(OBJECT_SELF, "use_lock") == 1,
	nDontLock = GetLocalInt(OBJECT_SELF, "dont_lock") == 1,
	nLockAtNight = GetLocalInt(OBJECT_SELF, "nightlock") == 1,
	nLockAtDay = GetLocalInt(OBJECT_SELF, "daylock") == 1,
	nPlot = GetLocalInt(OBJECT_SELF, "plot") == 1;


	if ( nPlot != GetPlotFlag(OBJECT_SELF) )
		SetPlotFlag(OBJECT_SELF, nPlot);

	if ( !nUseLocking )
		return;


	if ( !nDontLock && !GetIsDay() && !GetIsOpen(OBJECT_SELF) )
		SetLocked(OBJECT_SELF, nLockAtNight);

	if ( !nDontLock && GetIsDay() && !GetIsOpen(OBJECT_SELF) )
		SetLocked(OBJECT_SELF, nLockAtDay);
}
