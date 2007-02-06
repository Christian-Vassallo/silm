int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetTag(OBJECT_SELF) == "c_queen_w" || GetTag(OBJECT_SELF) == "c_queen_b" );
	return l_iResult;
}
