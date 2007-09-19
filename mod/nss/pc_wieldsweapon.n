int StartingConditional() {
	object oPC = GetPCSpeaker();
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int iBT = GetBaseItemType(oWeap);
	int iModelType, iWeaponType;

	if ( !GetIsObjectValid(oWeap) ) return FALSE;

	// 0 - single model
	// 1 - helmet
	// 2 - compound model
	// 3 - armor
	iModelType = StringToInt(Get2DAString("baseitems", "ModelType", iBT));

	// 0 - No weapon
	// nonzero - Weapon
	iWeaponType = StringToInt(Get2DAString("baseitems", "WeaponType", iBT));

	//disallow single modelled weapons
	if ( iModelType != 2 || !iWeaponType ) return FALSE;

	//disallow Kama (too many radically different weapon types connected to it)
	if ( iBT == BASE_ITEM_KAMA ) return FALSE;

	return TRUE;
}
