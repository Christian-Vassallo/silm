int StartingConditional() {
	object oPC = GetPCSpeaker();
	string sProceed = GetLocalString(oPC, "ConvList_Proceed");
	int iStT = GetLocalInt(oPC, "ConvList_StT");

	if ( sProceed != "" ) {
		SetCustomToken(iStT + 11, GetLocalString(oPC, "ConvList_PrCap"));
		return 1;
	}
	return 0;
}
