//::///////////////////////////////////////////////
//:: FileName dlg_underlvl7
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 09.04.2006 21:34:24
//:://////////////////////////////////////////////
int StartingConditional() {

	// Einschränkungen nach Klasse des Spielers
	int iPassed = 0;
	if ( GetHitDice(GetPCSpeaker()) < 7 )
		iPassed = 1;
	if ( iPassed == 0 )
		return FALSE;

	return TRUE;
}
