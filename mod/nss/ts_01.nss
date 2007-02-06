//::///////////////////////////////////////////////
//:: FileName ts_01
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 16.05.2005 13:17:54
//:://////////////////////////////////////////////
int StartingConditional() {

	// Einschränkungen nach Klasse des Spielers
	int iPassed = 0;
	if ( GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1 )
		iPassed = 1;
	if ( iPassed == 0 )
		return FALSE;

	if ( GetRacialType(GetPCSpeaker()) != RACIAL_TYPE_ANIMAL )
		return FALSE;

	return TRUE;
}
