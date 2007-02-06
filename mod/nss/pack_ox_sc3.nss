int StartingConditional() {
	int iPrice = GetLocalInt(OBJECT_SELF, "PRICE");

	if ( !iPrice ) return FALSE;

	SetCustomToken(30000, IntToString(iPrice / 10));

	if ( GetReputation(OBJECT_SELF, GetPCSpeaker()) >= 90 ) {
		return TRUE;
	}
	if ( !GetIsObjectValid(GetLocalObject(OBJECT_SELF, "PACK_OWNER")) ) {
		return TRUE;
	}

	return FALSE;

}
