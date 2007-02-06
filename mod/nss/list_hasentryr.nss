#include "inc_lists"

int StartingConditional() {
	object oPC = GetPCSpeaker();

	int iCurrent = GetLocalInt(oPC, "ConvList_Current");

	object oHolder = GetLocalObject(oPC, "ConvList_Holder");
	string sListTag = GetLocalString(oPC, "ConvList_Tag");

	if ( ( iCurrent < GetListCount(oHolder, sListTag) )
		&& ( GetListDisplayMode(oHolder, sListTag, iCurrent) < 0 ) ) {
		int iCurrent2 = GetLocalInt(oPC, "ConvList_Current2");
		int iStT = GetLocalInt(oPC, "ConvList_StT");

		SetCustomToken(iStT + iCurrent2,
			GetLocalString(oHolder, sListTag + "_title_" + IntToString(iCurrent)));
		return 1;
	}
	return 0;
}
