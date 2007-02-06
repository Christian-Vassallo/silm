int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetTag(OBJECT_SELF) == "c_pawn_w" || GetTag(OBJECT_SELF) == "c_pawn_b" );
	return l_iResult;
}
