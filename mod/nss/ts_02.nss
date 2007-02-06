//::///////////////////////////////////////////////
//:: FileName ts_02
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 16.05.2005 12:11:20
//:://////////////////////////////////////////////
int StartingConditional() {

	// Einschränkungen nach Klasse des Spielers
	int iPassed = 0;
	if ( GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) >= 1 )
		iPassed = 1;
	if ( iPassed == 0 )
		return FALSE;

	return TRUE;
}
