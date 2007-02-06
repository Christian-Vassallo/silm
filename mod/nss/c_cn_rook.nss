int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetTag(OBJECT_SELF) == "c_rook_w" || GetTag(OBJECT_SELF) == "c_rook_b" );
	return l_iResult;
}
