int StartingConditional() {
	if ( GetLocalInt(OBJECT_SELF, "NO_RESURRECT") ) return FALSE;

	return !GetIsObjectValid(GetLocalObject(OBJECT_SELF, "CURRENT_CORPSE"));
}
