void main() {
	object oPC = OBJECT_SELF;
	// Lythari!


	effect e = EffectPolymorph(POLYMORPH_TYPE_WOLF, FALSE);
	e = SupernaturalEffect(e);

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, e, oPC);

	if ( GetLocalInt(oPC, "wolf_white") )
		SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_DOG_WINTER_WOLF);
}
