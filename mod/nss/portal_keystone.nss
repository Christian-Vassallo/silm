#include "inc_keystone"

int StartingConditional() {
	int iResult = FALSE;
	object oPC = GetPCSpeaker();
	string sKeyStone = GetLocalString(OBJECT_SELF, "KeyStone");
	if ( sKeyStone != "" ) {
		if ( CheckKeyStone(sKeyStone, oPC) == TRUE ) {
			iResult = TRUE;
		}
	} else {
		iResult = TRUE;
	}
	return iResult;
}
