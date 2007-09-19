int StartingConditional() {
	int l_iResult;

	object oGM = GetNearestObjectByTag("c_gamemaster");
	int a = ( GetLocalInt(OBJECT_SELF, "nPiece") > 0
			 && GetLocalObject(oGM, "oWhitePlayer") != GetPCSpeaker() );
	int b = ( GetLocalInt(OBJECT_SELF, "nPiece") < 0
			 && GetLocalObject(oGM, "oBlackPlayer") != GetPCSpeaker() );
	l_iResult = a || b;
	return l_iResult;
}
