void main() {
	object oPC = GetLastUnlocked();
	string sKeyTag = GetLockKeyTag(OBJECT_SELF);
	int nKeyOwner = FALSE;
	object oItem = GetFirstItemInInventory(oPC);
	while ( GetIsObjectValid(oItem) ) {
		if ( GetTag(oItem) == sKeyTag ) {
			nKeyOwner = TRUE;
		}
		oItem = GetNextItemInInventory(oPC);
	}
	if ( GetIsDM(oPC) == TRUE || GetIsDMPossessed(oPC) == TRUE ) {
		nKeyOwner = TRUE;
	}
	// SC besitzt keinen Schluessel muss demzufolge Einbrecher sein
	if ( nKeyOwner != TRUE ) {
		object oWache = GetFirstObjectInArea();
		string sWache = GetLocalString(OBJECT_SELF, "wache");
		int sLaenge = GetStringLength(sWache);
		while ( GetIsObjectValid(oWache) ) {
			if ( GetStringLeft(GetTag(oWache), sLaenge) == sWache ) {
				if ( LineOfSightObject(oWache, oPC) ) {
					AssignCommand(oWache, ActionSpeakString("ALARM!! Eindringling!!"));
					AssignCommand(oWache, ActionAttack(oPC));
					AdjustReputation(oPC, oWache, -100);
					DelayCommand(300.0, AdjustReputation(oPC, oWache, 100));
				}
			}
			oWache = GetNextObjectInArea();
		}
	}
}
