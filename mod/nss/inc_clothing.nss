/* Script by 'gonar' adapted for Silbermarken
 * by Bernhard 'Elven' Stoeckner
 * Prolly not GPL source, so keep it low.
 */

/* Updates the appearance and clothing of oPC
 * to reflect the accessoires oPC has equipped.
 */
//void ClothUpdate(object oPC);

// const int CLOAK_MODEL = 30;

void PutCloak(object oPC, object oPiece);
void QuitCloak(object oPC, object oPiece);
void PutBelt(object oPC, object oPiece, object oBelt);
void QuitBelt(object oPC, object oPiece);
void PutGloves(object oPC, object oPiece, object oGloves);
void PutBracers(object oPC, object oPiece, object oGloves);
void QuitGloBra(object oPC, object oPiece);
void PutBoots(object oPC, object oPiece, object oBoots);
void QuitBoots(object oPC, object oPiece);


int IsCloakID(int id) {
	return id == 30 || id == 31 || id == 26 || id == 10;
}

/* implementation */

/* Updates oArmor to reflect changes and returns the model. * /
 * object Update(object oPC, object oArmor, int iModelId, int iValue) {
 * 	object oO = oArmor;
 * 	if (GetItemAppearance(oArmor, iModelId) != iValue) {
 * 		oO = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iModelId, iValue, 1);
 * 		DelayCommand(0.1, DestroyObject(oArmor));
 * 	}
 * 	return oO;
 * }
 *
 * void ClothUpdate(object oPC) {
 * 	if (!GetIsObjectValid(oPC) || GetLocalInt(oPC, "c_lock"))
 * 		return;
 *
 * 	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
 *
 * 	if (!GetIsObjectValid(oArmor)) /* not wearing armor * /
 * 		return;
 *
 * 	AssignCommand(oPC, ClearAllActions());
 * 	SetCommandable(FALSE, oPC);
 *
 * 	object
 * 		oBoots = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC),
 * 		oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC),
 * 		oBelt = GetItemInSlot(INVENTORY_SLOT_BELT, oPC),
 * 		oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC),
 * 		oArrows = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC),
 * 		oBolts = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
 *
 * 	if (GetIsObjectValid(oCloak))
 * 		Update(oPC, oArmor, ITEM_APPR_ARMOR_MODEL_NECK, 112);
 * 	else
 * 		Update(oPC, oArmor, ITEM_APPR_ARMOR_MODEL_NECK, 1);
 *
 *
 *
 * 	SetLocalInt(oPC, "c_lock", 1);
 * 	AssignCommand(oPC, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
 *
 * 	DelayCommand(3.0, SetLocalInt(oPC, "c_lock", 0)); // XXX: may provoke exploit, time-test it
 *
 * 	SetCommandable(TRUE, oPC);
 * }*/

void PutCloak(object oPC, object oPiece) {
	if ( GetLocalInt(oPiece, "c_cloaklock") )
		return;

	object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);

	if ( !GetIsObjectValid(oCloak) ) {
		SendMessageToPC(oPC, "woooaaah!!");
		return;

	}

	int nCloakModel = 30;
	if ( GetLocalInt(oCloak, "cloak_model") )
		nCloakModel = GetLocalInt(oCloak, "cloak_model");

	SendMessageToPC(oPC, "Model = " + IntToString(nCloakModel));

	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK) != nCloakModel ) {
		object oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK,
						   nCloakModel, TRUE);
		DestroyObject(oPiece);
		SetLocalInt(oItem, "c_cloaklock", 1);
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
		SetLocalInt(oItem, "c_cloaklock", 0);
	}
}

void QuitCloak(object oPC, object oPiece) {
	if ( GetLocalInt(oPiece, "c_cloaklock") )
		return;

	int oldApp = GetLocalInt(oPiece, "a_neck");
	if ( oldApp < 1 )
		oldApp = 1;

	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK) != oldApp ) {
		object oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK,
						   oldApp, TRUE);
		SetLocalInt(oItem, "c_cloaklock", 1);
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
		SetLocalInt(oItem, "c_cloaklock", 0);
		DestroyObject(oPiece);
	}
}

void PutBelt(object oPC, object oPiece, object oBelt) {
	if ( GetLocalInt(oPiece, "c_beltlock") )
		return;

	int iValue = GetLocalInt(oPiece, "a_belt");

	if ( iValue > 0
		&& GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT) != iValue ) {
		object oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT,
						   iValue, TRUE);
		SetLocalInt(oItem, "c_beltlock", 1);
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
		SetLocalInt(oItem, "c_beltlock", 0);
		DestroyObject(oPiece);
	}
}

void QuitBelt(object oPC, object oPiece) {
	if ( GetLocalInt(oPiece, "c_beltlock") )
		return;

	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT) != 1 ) {
		object oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT, 1,
						   TRUE);
		SetLocalInt(oItem, "c_beltlock", 1);
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
		SetLocalInt(oItem, "c_beltlock", 0);
		DestroyObject(oPiece);
	}
}

void PutGloves(object oPC, object oPiece, object oGloves) {
	if ( GetLocalInt(oPiece, "c_glovlock") )
		return;

	int changed = 0;
	object oItem = oPiece;

	int iValue = GetLocalInt(oPiece, "a_rhand");
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	iValue = GetLocalInt(oPiece, "a_lhand");
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	iValue = GetLocalInt(oPiece, "a_rforearm");
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	iValue = GetLocalInt(oPiece, "a_lforearm");
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM, iValue,
					TRUE);
		DestroyObject(oPiece);
		changed = 1;
	}


	SetLocalInt(oItem, "c_glovlock", 1);
	if ( changed )
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
	SetLocalInt(oItem, "c_glovlock", 0);
}





/* Bracers */

void PutBracers(object oPC, object oPiece, object oGloves) {
	if ( GetLocalInt(oPiece, "c_glovlock") )
		return;

	int changed = 0;
	object oItem = oPiece;

	int iValue = GetLocalInt(oPiece, "a_rforearm");
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	iValue = GetLocalInt(oPiece, "a_lforearm");
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
	}

	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
	}

	SetLocalInt(oItem, "c_glovlock", 1);
	if ( changed )
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
	SetLocalInt(oItem, "c_glovlock", 0);
}



void QuitGloBra(object oPC, object oPiece) {
	if ( GetLocalInt(oPiece, "c_glovlock") )
		return;

	object oItem = oPiece;
	int changed = 0;

	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}
	if ( GetItemAppearance(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	SetLocalInt(oItem, "c_glovlock", 1);
	if ( changed )
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
	SetLocalInt(oItem, "c_glovlock", 0);
}




void PutBoots(object oPC, object oPiece, object oBoots) {
	if ( GetLocalInt(oPiece, "c_bootlock") )
		return;

	object oItem = oPiece;
	int iValue = 0;
	int changed = 0;

	iValue = GetLocalInt(oItem, "a_rshin");
	if ( iValue > 0
		&& GetItemAppearance(oPiece,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	iValue = GetLocalInt(oItem, "a_lshin");
	if ( iValue > 0
		&& GetItemAppearance(oPiece,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	iValue = GetLocalInt(oItem, "a_rfoot");
	if ( iValue > 0
		&& GetItemAppearance(oPiece,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT, iValue,
					TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}

	iValue = GetLocalInt(oItem, "a_lfoot");
	if ( iValue > 0
		&& GetItemAppearance(oPiece,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT) != iValue ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, iValue,
					TRUE);
		DestroyObject(oPiece);
		changed = 1;
	}

	SetLocalInt(oItem, "c_bootlock", 1);

	if ( changed ) {
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
	}

	SetLocalInt(oItem, "c_bootlock", 0);
}


void QuitBoots(object oPC, object oPiece) {
	if ( GetLocalInt(oPiece, "c_bootlock") )
		return;

	object oItem = oPiece;
	int changed = 0;

	if ( GetItemAppearance(oItem,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}
	if ( GetItemAppearance(oItem,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}
	if ( GetItemAppearance(oItem,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, 1, TRUE);
		DestroyObject(oPiece);
		oPiece = oItem;
		changed = 1;
	}
	if ( GetItemAppearance(oItem,  ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT) != 1 ) {
		oItem = CopyItemAndModify(oPiece, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT, 1, TRUE);
		DestroyObject(oPiece);
		changed = 1;
	}


	SetLocalInt(oItem, "c_bootlock", 1);

	if ( changed ) {
		AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
	}

	SetLocalInt(oItem, "c_bootlock", 0);
}
