void main() {
	SetLocalInt(OBJECT_SELF, "nWhiteAssigned", 1);
	SetLocalObject(OBJECT_SELF, "oWhitePlayer", GetPCSpeaker());

	if ( GetLocalInt(OBJECT_SELF, "nBlackAssigned") && GetLocalInt(OBJECT_SELF, "GameState") == 2 )
		SetLocalInt(OBJECT_SELF, "GameState", 1);
}
