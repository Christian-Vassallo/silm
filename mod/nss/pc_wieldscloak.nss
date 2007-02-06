int StartingConditional() {
	object oPC = GetPCSpeaker();
	object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);

	if ( !GetIsObjectValid(oCloak) )
		return FALSE;

	if ( GetStringLowerCase(GetStringLeft(GetResRef(oCloak), 6)) != "umhang" )
		return FALSE;


	SetLocalObject(oPC, "CHG_CURRENT_ARM", oCloak);

	return TRUE;
}
