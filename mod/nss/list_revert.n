void main() {
	object oPC = GetPCSpeaker();
	string sRevert = GetLocalString(oPC, "ConvList_Revert");

	if ( sRevert != "" ) {
		SetLocalObject(OBJECT_SELF, "ConvList_PC", oPC);
		ExecuteScript(sRevert, OBJECT_SELF);
	}

}
