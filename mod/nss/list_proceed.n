void main() {
	object oPC = GetPCSpeaker();
	string sProceed = GetLocalString(oPC, "ConvList_Proceed");

	if ( sProceed != "" ) {
		SetLocalObject(OBJECT_SELF, "ConvList_PC", oPC);
		ExecuteScript(sProceed, OBJECT_SELF);
	}

}
