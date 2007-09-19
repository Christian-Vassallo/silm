float AREA_CLEAN_TIME = 600.0f;

void _Run_Areaclean(object oArea) {
	object oMon;
	int iState;

	iState = GetLocalInt(oArea, "AREA_ENTER_COUNT");
	if ( iState > 0 )
		SetLocalInt(oArea, "AREA_ENTER_COUNT", iState - 1);

	if ( iState > 1 ) return;

	oMon = GetFirstObjectInArea(oArea);
	while ( GetIsObjectValid(oMon) ) {
		if ( GetIsEncounterCreature(oMon) ) DestroyObject(oMon);
		oMon = GetNextObjectInArea(oArea);
	}
}

void Cl_Areaentered() {
	int iState;

	if ( !GetIsPC(GetEnteringObject()) ) return;

	if ( GetLocalInt(OBJECT_SELF, "AREA_POPULATED") ) return;

	SetLocalInt(OBJECT_SELF, "AREA_POPULATED", 1);

	iState = GetLocalInt(OBJECT_SELF, "AREA_ENTER_COUNT") + 1;

	SetLocalInt(OBJECT_SELF, "AREA_ENTER_COUNT", iState);

}

void Cl_Arealeft() {
	object oPC = GetFirstPC();

	if ( !GetIsPC(GetExitingObject()) ) return;

	while ( GetIsObjectValid(oPC) ) {
		if ( GetArea(oPC) == OBJECT_SELF && GetExitingObject() != oPC )
			return;

		oPC = GetNextPC();
	}
	DeleteLocalInt(OBJECT_SELF, "AREA_POPULATED");
	DelayCommand(AREA_CLEAN_TIME, _Run_Areaclean(OBJECT_SELF));
}

