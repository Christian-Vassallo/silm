int StartingConditional() {
	int iResult;

	iResult = ( GetLocalInt(GetNearestObjectByTag("c_gamemaster"), "GameState") == 3 );
	return iResult;
}
