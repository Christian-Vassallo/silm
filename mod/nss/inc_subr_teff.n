void SR_RemoveTempEffect(object oPC, int iEffType) {
	effect eEff = GetFirstEffect(oPC);

	while ( GetIsEffectValid(eEff) ) {
		if ( GetEffectSubType(eEff) == SUBTYPE_SUPERNATURAL
			&& GetEffectType(eEff) == iEffType )
			RemoveEffect(oPC, eEff);
		eEff = GetNextEffect(oPC);
	}
}

