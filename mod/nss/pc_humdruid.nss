int StartingConditional() {
	object oPC = GetPCSpeaker();

	return ( GetRacialType(oPC) == RACIAL_TYPE_HUMAN )
		   && ( ( GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 )
			   || ( GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0 ) );
}
