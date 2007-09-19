void main() {
	object oArea = GetArea(GetLastUsedBy());
	string sBell = GetLocalString(OBJECT_SELF, "bell");
	string sAreaName = GetName(oArea); // GetLocalString(OBJECT_SELF, "area");

	int iPlayed;

	object oPC = GetFirstPC();
	SpeakString("*DONG, DONG* - Der Alarmgong '" + sAreaName + "' ertönt!!", TALKVOLUME_SHOUT);
	while ( GetIsObjectValid(oPC) ) {
		oArea = GetArea(oPC);

		iPlayed = GetLocalInt(oArea, "tempbell");

		if ( !iPlayed ) {
			AssignCommand(oPC, PlaySound("as_cv_bell2"));
			// verhindert multiple Glocken bei mehreren Leuten im Gebiet
			SetLocalInt(oArea, "tempbell", 1);
			DelayCommand(0.3f, DeleteLocalInt(oArea, "tempbell"));
		}

		oPC = GetNextPC();
	}
}
