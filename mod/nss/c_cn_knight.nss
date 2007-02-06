int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetTag(OBJECT_SELF) == "c_knight_w" || GetTag(OBJECT_SELF) == "c_knight_b" );
	return l_iResult;
}
