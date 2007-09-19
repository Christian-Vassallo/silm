//::///////////////////////////////////////////////
//:: FileName dlg_overlvl6
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 09.04.2006 21:30:25
//:://////////////////////////////////////////////
int StartingConditional() {

	// Einschränkungen nach Klasse des Spielers
	int iPassed = 0;
	if ( GetHitDice(GetPCSpeaker()) >= 7 )
		iPassed = 1;
	if ( iPassed == 0 )
		return FALSE;

	return TRUE;
}
