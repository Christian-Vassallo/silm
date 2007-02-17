#include "_gen"
#include "inc_horse"
#include "inc_torches"
#include "_clothing"

void ClothEquip();

void main() {
	object oPC = GetPCItemLastEquippedBy();
	object oItem = GetPCItemLastEquipped();

	CheckRideWithWeapons(oPC);

	if ( GetTag(oItem) == "NW_IT_TORCH001" )
		EquippedTorch(oPC, oItem);


	int nNow = GetUnixTimestamp();
	int nSh = 0;
	if ( "s_ebs" == GetTag(oItem) ) {
		nSh = GetLocalInt(oItem, "ebs_create");
		if ( nSh == 0 || nNow - nSh > 3600 * 3 )
			DestroyObject(oItem);
		return;
	}


	ClothEquip();

}

void ClothEquip() {
	if ( !GetLocalInt(GetModule(), "clothchange") )
		return;


	object oItem = GetPCItemLastEquipped();
	object oPC   = GetPCItemLastEquippedBy();

	if ( GetLocalInt(oPC, "noclothchange") )
		return;


	if ( !GetIsPC(oPC) || GetIsDM(oPC) )
		return;

	// prevent exploit
	//SetCommandable(FALSE, oPC);
	//AssignCommand(oPC, ClearAllActions());

	int iType = GetBaseItemType(oItem);
	int iValue = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK);
	int iValue2 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND);
	int iValue3 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND);
	int iValue4 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM);
	int iValue5 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM);
	int iValue6 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT);
	int iValue7 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN);
	int iValue8 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN);
	int iValue9 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT);
	int iValueA = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT);

	if ( BASE_ITEM_ARMOR == iType && !GetLocalInt(oItem, "a_neck") ) {
		/* Save default values of the relevant apptypes on this armor */
		SetLocalInt(oItem, "a_neck", iValue); SetLocalInt(oItem, "a_rhand", iValue2);
		SetLocalInt(oItem, "a_lhand", iValue3); SetLocalInt(oItem, "a_rforearm", iValue4);
		SetLocalInt(oItem, "a_lforearm", iValue5); SetLocalInt(oItem, "a_belt", iValue6);
		SetLocalInt(oItem, "a_lshin", iValue7); SetLocalInt(oItem, "a_rshin", iValue8);
		SetLocalInt(oItem, "a_lfoot", iValue9); SetLocalInt(oItem, "a_rfoot", iValueA);
		// SendMessageToPC(oPC, "Default appearance on armor model was saved.");
	}


	/* player equips a cloak */
	if ( iType == BASE_ITEM_CLOAK && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) ) {
		PutCloak(oPC, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
	}/* player equips another armor than the current one and has neck value !- cloak - apply new cloak */
	else if ( !IsCloakID(iValue)
			 &&
			 iType
			 ==
			 BASE_ITEM_ARMOR && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)) ) {
		PutCloak(oPC, oItem);
	}/* remove cloak if current armor has cloak */ else if ( IsCloakID(iValue)
															&& iType == BASE_ITEM_ARMOR
															&& ( !GetIsObjectValid(GetItemInSlot(
																		INVENTORY_SLOT_CLOAK, oPC)) ) ) {
		QuitCloak(oPC, oItem);
	}/* PC equips belt and has armor */ else if ( GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
												 && iType == BASE_ITEM_BELT ) {
		PutBelt(oPC, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), oItem);
	}/* PC equips armor and has belt */ else if (/*iValue6 != 15 && iValue6 != 6 && iValue6 != 8 && iValue6 != 14 && iValue6 != 16 &&
												  * iValue6 != 12 && iValue6 != 11 && iValue6 != 10 && iValue6 != 9 && */
		iValue6 <= 1
		&& iType == BASE_ITEM_ARMOR && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_BELT, oPC)) ) {
		PutBelt(oPC, oItem, GetItemInSlot(INVENTORY_SLOT_BELT, oPC));
	}/* PC equips armor and has no belt - remove from appearance */ else if (
		iValue6 > 1
		&& iType == BASE_ITEM_ARMOR && ( !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_BELT, oPC)) ) ) {
		QuitBelt(oPC, oItem);
	}/* PC equips gloves and wears armor */ else if (
		iType == BASE_ITEM_GLOVES
		&& GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) ) {
		PutGloves(oPC, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), oItem);
	}/* PC equips bracers and wears armor */ else if ( GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST,
															  oPC))
													  && iType == BASE_ITEM_BRACER ) {
		PutBracers(oPC, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), oItem);
	}/* PC equips armor and wears either bracers or gloves */ else if (
		( iValue2 < 2 || iValue3 < 2 || iValue4 < 2 || iValue5 < 2 )
		&& iType == BASE_ITEM_ARMOR && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC))
	) {
		object oGloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
		if ( GetBaseItemType(oGloves) == BASE_ITEM_GLOVES )
			PutGloves(oPC, oItem, oGloves);
		if ( GetBaseItemType(oGloves) == BASE_ITEM_BRACER )
			PutBracers(oPC, oItem, oGloves);
	}/* PC equips armor and wears no gloves or bracers */ else if ( ( iValue2 >= 2
																	 || iValue3 >= 2
																	 || iValue4 >= 2 || iValue5 >= 2 )
																   && iType == BASE_ITEM_ARMOR
																   && !GetIsObjectValid(GetItemInSlot(
																		   INVENTORY_SLOT_ARMS, oPC)) ) {
		QuitGloBra(oPC, oItem);
	}/* PC equips boots and has armor */ else if (
		iType == BASE_ITEM_BOOTS
		&& GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) ) {
		PutBoots(oPC, GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), oItem);
	}/* PC equips armor and has boots */ else if ( iType == BASE_ITEM_ARMOR
												  && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC))
	) {
		PutBoots(oPC, oItem, GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC));
	}/* PC equips armor and has no boots */ else if ( iType == BASE_ITEM_ARMOR
													 && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_BOOTS,
															 oPC))
	) {
		QuitBoots(oPC, oItem);
	}

	//DelayCommand(COMMANDABLEFUDGE, SetCommandable(TRUE, oPC));
}
