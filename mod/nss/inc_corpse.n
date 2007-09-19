#include "inc_corpse_eff"
#include "inc_corpse_def"

void FilterND(object oWho) {
	object oItem = GetFirstItemInInventory(oWho);
	while ( GetIsObjectValid(oItem) ) {
		if ( !GetDroppableFlag(oItem) || GetItemCursedFlag(oItem) ) DestroyObject(oItem);
		oItem = GetNextItemInInventory(oWho);
	}
}

void DestroyInventory(object oWho, int iSpareND = FALSE, int iThreaded = FALSE) {
	int i = 1;
	object oItem, oItem2;
	for ( i = 0; i < NUM_INVENTORY_SLOTS; i++ )
		if ( GetIsObjectValid(oItem = GetItemInSlot(i, oWho)) )
			DestroyObject(oItem);
	if ( iThreaded ) {
		oItem = GetFirstItemInInventory(oWho);
		while ( GetIsObjectValid(oItem) ) {
			DeleteLocalInt(oItem, "Stashed");
			oItem = GetNextItemInInventory(oWho);
		}

		oItem = GetFirstItemInInventory(oWho);
		while ( GetIsObjectValid(oItem) ) {
			oItem2 = GetFirstItemInInventory(oItem);
			while ( GetIsObjectValid(oItem2) ) {
				SetLocalInt(oItem2, "Stashed", 1);
				oItem2 = GetNextItemInInventory(oItem);
			}
			oItem = GetNextItemInInventory(oWho);
		}
	}

	oItem = GetFirstItemInInventory(oWho);
	while ( GetIsObjectValid(oItem) ) {
		if ( !iSpareND || !( !GetDroppableFlag(oItem) || GetItemCursedFlag(oItem) ) ) {
			if ( !iThreaded )
				DestroyObject(oItem);
			else if ( !GetLocalInt(oItem, "Stashed") )
				DelayCommand(0.2f * IntToFloat(i++), DestroyObject(oItem));
		}
		oItem = GetNextItemInInventory(oWho);
	}
	TakeGoldFromCreature(GetGold(oWho), oWho, TRUE);
}

object MakeCorpseObject(object oContainer, object oCarrier = OBJECT_INVALID) {
	object oCorpseOb;
	object oOriginalBody = GetLocalObject(oContainer, "Body");

	if ( !GetIsObjectValid(oCarrier) ) oCarrier = oContainer;

	if ( GetGender(oOriginalBody) == GENDER_FEMALE )
		oCorpseOb = CreateItemOnObject("loot_corps_w", oCarrier);
	else
		oCorpseOb = CreateItemOnObject("loot_corps_m", oCarrier);

	SetLocalObject(oCorpseOb, "ORIG_BODY", oOriginalBody);
	SetLocalObject(oCorpseOb, "CONTAINER", oContainer);
	SetLocalObject(oOriginalBody, "PICKUP", oCorpseOb);

	SetName(oCorpseOb, GetName(oOriginalBody));

	return oCorpseOb;
}

object SpawnCorpse(object oOriginalBody, int iWasPC = FALSE) {
	vector vPos = GetPosition(oOriginalBody);
	vector vSinkIt = Vector(vPos.x, vPos.y, vPos.z - 0.11f);
	location lSpot = Location(GetArea(oOriginalBody), vSinkIt, GetFacing(oOriginalBody));

	object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, "loot_corps", lSpot);
	object oPickCorpse;
	object oItem;

	if ( !GetIsObjectValid(oCorpse) ) return OBJECT_INVALID;

	DESTRUCT_TIME = GetLocalFloat(oOriginalBody, "DESTRUCT_TIME");

	SetLocalObject(oOriginalBody, "PLACEABLE", oCorpse);
	SetLocalFloat(oCorpse, "DESTRUCT_TIME", DESTRUCT_TIME);
	SetLocalObject(oCorpse, "Body", oOriginalBody);
	SetLocalInt(oCorpse, "WAS_PC_CORPSE",
		GetLocalInt(oOriginalBody, "WAS_PC_CORPSE"));
	SetLocalObject(oCorpse, "PC_CORPSE",
		GetLocalObject(oOriginalBody, "PC_CORPSE"));

	if ( GetLocalInt(oOriginalBody, "PLOT_FLAG") )
		SetPlotFlag(oCorpse, TRUE);
	else {
		if ( DESTRUCT_TIME > 0.0 )
			DelayCommand(DESTRUCT_TIME, SignalEvent(oCorpse, EventUserDefined(110)));
	}

	SetLocked(oCorpse, TRUE);
	DelayCommand(1.0f, SetLocked(oCorpse, FALSE));
	SetName(oCorpse, "Kadaver: " + GetName(oOriginalBody));

	return oCorpse;
}

object SpawnPCCorpse(object oPC, int iOldPCLocation = FALSE) {
	int i;
	location lCorpseLoc = GetLocation(oPC);
	object oFakeCorpse;
	object oItem;

	if ( iOldPCLocation ) lCorpseLoc = GetLocalLocation(oPC, "CORPSE_LOCATION");

	oFakeCorpse = CopyObject(oPC, lCorpseLoc);
	if ( !GetIsDead(oFakeCorpse) )
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(), oFakeCorpse);

	if ( !GetIsObjectValid(oFakeCorpse) ) return OBJECT_INVALID;

	ClearPersonalReputation(oPC, oFakeCorpse);
	ClearPersonalReputation(oFakeCorpse, oPC);
	ChangeToStandardFaction(oFakeCorpse, STANDARD_FACTION_COMMONER);

	SetLocalObject(oFakeCorpse, "PC_CORPSE", oPC);
	SetLocalObject(oPC, "PC_CORPSE", oFakeCorpse);
	SetLocalInt(oFakeCorpse, "PLOT_FLAG", 1);

	if ( !GetIsObjectValid(SpawnCorpse(oFakeCorpse, TRUE)) ) return OBJECT_INVALID;

	AssignCommand(oFakeCorpse, SetIsDestroyable(FALSE, TRUE));
	SetLocalLocation(oPC, "CORPSE_LOCATION", GetLocation(oFakeCorpse));
	SetLocalInt(oPC, "IS_DEAD", 1);

	return oFakeCorpse;
}

object MoveCorpseObj_2(object oCorpseOb, object oCorpsePlac, object oLocation, int ReCreatePlac = TRUE) {
	object oPC;
	object oItem, oCopy;
	object oNewCorpse;
	int nGold = 0;
	int i;

	if ( GetIsObjectValid(oCorpseOb) ) {
		oNewCorpse = CopyObject(oCorpseOb, GetLocation(oLocation));
		oItem = GetFirstItemInInventory(oCorpseOb);

		while ( GetIsObjectValid(oItem) ) {
			DestroyObject(oItem);
			oItem = GetNextItemInInventory(oCorpseOb);
		}

		for ( i = 0; i < NUM_INVENTORY_SLOTS; i++ )
			if ( GetIsObjectValid(oItem = GetItemInSlot(i, oCorpseOb)) )
				DestroyObject(oItem);
		AssignCommand(oCorpseOb, SetIsDestroyable(TRUE));
		TakeGoldFromCreature(GetGold(oCorpseOb), oCorpseOb, TRUE);
		DestroyObject(oCorpseOb);

		AssignCommand(oNewCorpse, SetIsDestroyable(FALSE, TRUE));

		SetLocalObject(oNewCorpse, "PC_CORPSE", ( oPC = GetLocalObject(oCorpseOb, "PC_CORPSE") ));
		if ( GetIsObjectValid(oPC) )
			SetLocalObject(oPC, "PC_CORPSE", oNewCorpse);

		SetLocalObject(oNewCorpse, "PICKUP", GetLocalObject(oCorpseOb, "PICKUP"));
		SetLocalInt(oNewCorpse, "PLOT_FLAG", GetLocalInt(oCorpseOb, "PLOT_FLAG"));
		SetLocalInt(oNewCorpse, "WAS_PC_CORPSE", GetLocalInt(oCorpseOb, "WAS_PC_CORPSE"));
		SetLocalInt(oNewCorpse, "CORPSE_NOT_PORTABLE", GetLocalInt(oCorpseOb, "CORPSE_NOT_PORTABLE"));
		SetLocalFloat(oNewCorpse, "DESTRUCT_TIME", GetLocalFloat(oCorpseOb, "DESTRUCT_TIME"));
		SetLocalInt(oNewCorpse, "Copying", 1);

	}

	if ( GetIsObjectValid(oCorpsePlac) ) {
		DestroyObject(oCorpsePlac);
	}

	if ( GetIsObjectValid(oNewCorpse) && ReCreatePlac ) {
		SpawnCorpse(oNewCorpse, GetIsObjectValid(oPC));
		if ( GetIsObjectValid(oPC) )
			SetLocalLocation(oPC, "CORPSE_LOCATION", GetLocation(oNewCorpse));
	}
	return oNewCorpse;
}

void MoveCorpseObject(object oCorpsePick, object oLocation, int ReCreatePlac = TRUE) {
	object oCorpseOb = GetLocalObject(oCorpsePick, "ORIG_BODY");
	object oCorpsePlac = GetLocalObject(oCorpsePick, "CONTAINER");

	object oNewCorpse = MoveCorpseObj_2(oCorpseOb, oCorpsePlac, oLocation, ReCreatePlac);

	SetLocalObject(oCorpsePick, "ORIG_BODY", oNewCorpse);

}

object TakeCorpseObject(object oCorpsePlac, object oCarrier) {
	object oCarry = MakeCorpseObject(oCorpsePlac, oCarrier);
	MoveCorpseObject(oCarry, GetObjectByTag("LOOT_WP"), FALSE);
	return oCarry;
}

void DropCorpseObject(object oCorpseOb, object oCarrier) {
	MoveCorpseObject(oCorpseOb, oCarrier, TRUE);
	DelayCommand(0.2f, DestroyObject(oCorpseOb));
}

void DropCorpses(object oCarrier) {
	if ( !GetIsObjectValid(GetItemPossessedBy(oCarrier, "loot_corpse")) ) return;

	object oItem = GetFirstItemInInventory(oCarrier);
	while ( GetIsObjectValid(oItem) ) {
		if ( GetTag(oItem) == "loot_corpse" )
			DropCorpseObject(oItem, oCarrier);
		oItem = GetNextItemInInventory(oCarrier);
	}
}

/*
 * PC is about to log out while dead, remove traces
 */
void LogoutPC(object oPC) {
	object oFakeCorpse = GetLocalObject(oPC, "PC_CORPSE");

	// Drop Corpses when a carrier logs out
//  DropCorpses(oPC);

	if ( !GetIsObjectValid(oFakeCorpse) ) return;

	object oCorpsePlac = GetLocalObject(oFakeCorpse, "PLACEABLE");
	object oCorpsePick = GetLocalObject(oFakeCorpse, "PICKUP");

	//When the corpse is carried around it will reappear at that location where
	//the bearer was as the PC in question logged out
	if ( GetIsObjectValid(oCorpsePick) ) {
		object oPoss = GetItemPossessor(oCorpsePick);
		if ( GetIsObjectValid(GetArea(oPoss)) )
			SetLocalLocation(oPC, "CORPSE_LOCATION", GetLocation(oPoss));
	}

//  Eff_RotAway(oFakeCorpse);

	DestroyInventory(oFakeCorpse);
	AssignCommand(oFakeCorpse, SetIsDestroyable(TRUE));
	DestroyObject(oFakeCorpse);
	DestroyInventory(oCorpsePlac);
	DestroyObject(oCorpsePlac);
	DestroyObject(oCorpsePick);
}

void LoginPC(object oPC) {
	if ( GetLocalInt(oPC, "IS_DEAD") )
		SpawnPCCorpse(oPC, TRUE);
}

/*
 * Merge PC back with his corpse
 */
void ReIntegratePC(object oPC) {
	object oFakeCorpse = GetLocalObject(oPC, "PC_CORPSE");
	object oCorpsePlac = GetLocalObject(oFakeCorpse, "PLACEABLE");
	object oItem;

	if ( !GetIsObjectValid(oPC) ) return;

	DeleteLocalInt(oPC, "IS_DEAD");

	if ( !GetIsObjectValid(oCorpsePlac) )
		oCorpsePlac = SpawnCorpse(oFakeCorpse, TRUE);

	location lCorpsePlac = GetLocation(oCorpsePlac);
	object oCorpsePick = GetLocalObject(oFakeCorpse, "PICKUP");

	DestroyObject(oCorpsePick);

	AssignCommand(oPC, JumpToLocation(lCorpsePlac));
	DestroyObject(oCorpsePlac);
	DestroyInventory(oFakeCorpse);
	AssignCommand(oFakeCorpse, SetIsDestroyable(TRUE));
	DestroyObject(oFakeCorpse);
}

void DestroyOldCorpse(object oFakeCorpse, object oCorpsePlac) {
	DestroyInventory(oFakeCorpse);
	DestroyObject(oFakeCorpse);
	AssignCommand(oFakeCorpse, SetIsDestroyable(TRUE));
	DestroyObject(oCorpsePlac);
}

void DisconnectPlayerCorpse(object oPC) {
	object oFakeCorpse = SpawnPCCorpse(oPC, TRUE);
	object oCloth;

	//Unlink PC from, Corpse
	DeleteLocalObject(oPC, "PC_CORPSE");
	DeleteLocalObject(oFakeCorpse, "PC_CORPSE");
	DeleteLocalObject(GetLocalObject(oFakeCorpse, "PLACEABLE"), "PC_CORPSE");
	SetLocalInt(oFakeCorpse, "WAS_PC_CORPSE", 1);

	DeleteLocalInt(oPC, "IS_DEAD");

	//Fake Corpse doesn't contain Non-Droppables which remain with the PC itself
//  AssignCommand(oFakeCorpse,DelayCommand(0.5f,FilterND(oFakeCorpse)));
	DestroyInventory(oPC, TRUE, TRUE);
	oCloth = CreateItemOnObject("lc_deadcloth", oPC);
	AssignCommand(oPC, ActionEquipItem(oCloth, INVENTORY_SLOT_CHEST));
}

/*
 * PC starts a new reincarnation, let him start nekkid out with the ties
 * to the old corpse removed
 */
void ReincarnatePC(object oPC) {
	object oFakeCorpse = GetLocalObject(oPC, "PC_CORPSE");
	object oCorpsePlac = GetLocalObject(oFakeCorpse, "PLACEABLE");
	object oCorpsePick = GetLocalObject(oFakeCorpse, "PICKUP");

	if ( !GetIsObjectValid(oFakeCorpse) ) return;

	//When the corpse is carried around, have it dropped at the location of the carrier
	if ( GetIsObjectValid(oCorpsePick) ) {
		object oPoss = GetItemPossessor(oCorpsePick);
		if ( GetIsObjectValid(GetArea(oPoss)) )
			SetLocalLocation(oPC, "CORPSE_LOCATION", GetLocation(oPoss));
		DestroyObject(oCorpsePick);
	}

//  SetLocalLocation(oPC,"CORPSE_LOCATION",GetLocation(oFakeCorpse));

	//Have old Fake corpse destroyed
	DelayCommand(0.3f, DestroyOldCorpse(oFakeCorpse, oCorpsePlac));
	DeleteLocalInt(oPC, "IS_DEAD");

	//As an alternative, overlay the location of the disappearing corpse
	//with a raise dead and a summoning effect to denote that the player
	//has been transported elsewhere and been resurrected.
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
		EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), GetLocation(oFakeCorpse), 0.0f);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
		EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oFakeCorpse), 0.0f);

	//Create new Fake corpse with player's worldly possessions
	//DisconnectPlayerCorpse(oPC);
}

