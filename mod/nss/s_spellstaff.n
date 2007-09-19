/*
 * Spellstaff. Druid 4
 */

void main() {
	object oPC = OBJECT_SELF;

	object oTarget = GetSpellTargetObject();
	int nDC = GetSpellSaveDC(); // gets the DC required to save against the effects of the spell
	int nLevel = GetCasterLevel(oPC); // gets the level the PC cast the spell as

	if ( GetBaseItemType(oTarget) != BASE_ITEM_QUARTERSTAFF ) {
		FloatingTextStringOnCreature("Zauber fehlgeschlagen: Ziel muss ein Stab sein.", oPC, FALSE);
		return;
	}


	int bCannot = FALSE;
	itemproperty ip = GetFirstItemProperty(oTarget);

	while ( GetIsItemPropertyValid(ip) ) {
		if ( GetItemPropertyType(ip) == ITEM_PROPERTY_CAST_SPELL ) {
			bCannot = TRUE;
			break;
		}
		ip = GetNextItemProperty(oTarget);
	}

	if ( bCannot ) {
		FloatingTextStringOnCreature("Zauber fehlgeschlagen: Auf diesem Stab liegt bereits ein Zauber.", oPC,
			FALSE);
		return;
	}

	SetLocalObject(oPC, "spellstaff", oTarget);
	FloatingTextStringOnCreature(
		"Zauber erfolgreich: Nimm den Stab nun in die Hand und rufe den Zauber, den du dem Stab auferlegen willst.",
		oPC, FALSE);
}
