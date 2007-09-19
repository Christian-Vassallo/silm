#include "_gen"
#include "inc_lists"
#include "inc_2dacache"
#include "_const"

//#include "x2_inc_itemprop"



const string
CT = "polymorph",
HEAD = "Bitte Wildshape-Typus waehlen:";

// Returns the HitDice for nPolymorphForm
int GetHD(int nPoly);

// Returns if oTarget can morph into nPoly
int GetCanMorph(object oTarget, int nPoly);

void main() {
	object oPC = OBJECT_SELF;

	object oTarget = oPC;

	int nDC = GetSpellSaveDC(); // gets the DC required to save against the effects of the spell
	int nLevel = GetCasterLevel(oPC); // gets the level the PC cast the spell as
	int nMeta = GetMetaMagicFeat();



	// dont allow this spell on incorporals or gaseous forms
	if ( FALSE ) {
		Floaty("Koerperlose Kreaturen oder Gas-Formen koennen nicht polymorphen.");
		return;
	}

	if ( !GetIsPC(oPC) ) {
		Floaty("Nicht-Spieler-Charaktere koennen nicht polymorphen.");
		return;
	}

	SetLocalObject(oPC, "polymorph_target", oTarget);


	int nFemale = GENDER_MALE != GetGender(oTarget);
	int nFP = 0;

	ClearList(oPC, CT);


	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_GIANT_SPIDER) ) {
		AddListItem(oPC, CT, "Riesenspinne");
		SetListInt(oPC, CT, POLYMORPH_TYPE_GIANT_SPIDER);
	}

	/*if (GetCanMorph(oTarget, POLYMORPH_TYPE_TROLL)) {
	 * 	AddListItem(oPC, CT, "Troll");
	 * 	SetListInt(oPC, CT, POLYMORPH_TYPE_TROLL);
	 * } */

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_BADGER) ) {
		AddListItem(oPC, CT, "Dachs");
		SetListInt(oPC, CT, POLYMORPH_TYPE_BADGER);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_BOAR) ) {
		AddListItem(oPC, CT, "Eber");
		SetListInt(oPC, CT, POLYMORPH_TYPE_BOAR);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_BROWN_BEAR) ) {
		AddListItem(oPC, CT, "Braunbaer");
		SetListInt(oPC, CT, POLYMORPH_TYPE_BROWN_BEAR);
	}


	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_BAT) ) {
		AddListItem(oPC, CT, "Fledermaus");
		SetListInt(oPC, CT, POLYMORPH_TYPE_BAT);
		SetLocalString(oPC, "polymorph_type", "fly");
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_CHICKEN) ) {
		AddListItem(oPC, CT, "Huhn");
		SetListInt(oPC, CT, POLYMORPH_TYPE_CHICKEN);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_RAVEN) ) {
		AddListItem(oPC, CT, "Rabe");
		SetListInt(oPC, CT, POLYMORPH_TYPE_RAVEN);
		SetLocalString(oPC, "polymorph_type", "fly");
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_FALCON) ) {
		AddListItem(oPC, CT, "Falke");
		SetListInt(oPC, CT, POLYMORPH_TYPE_FALCON);
		SetLocalString(oPC, "polymorph_type", "fly");
	}


	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_GIANTEAGLE) ) {
		AddListItem(oPC, CT, "Riesenadler");
		SetListInt(oPC, CT, POLYMORPH_TYPE_GIANTEAGLE);
		SetLocalString(oPC, "polymorph_type", "fly");
	}


	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_PANTHER) ) {
		AddListItem(oPC, CT, "Panther");
		SetListInt(oPC, CT, POLYMORPH_TYPE_PANTHER);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_FOX) ) {
		AddListItem(oPC, CT, "Fuchs");
		SetListInt(oPC, CT, POLYMORPH_TYPE_FOX);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_WOLF) ) {
		AddListItem(oPC, CT, "Wolf");
		SetListInt(oPC, CT, POLYMORPH_TYPE_WOLF);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_WINTERWOLF) ) {
		AddListItem(oPC, CT, "Winterwolf");
		SetListInt(oPC, CT, POLYMORPH_TYPE_WINTERWOLF);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_COW) ) {
		AddListItem(oPC, CT, "Kuh");
		SetListInt(oPC, CT, POLYMORPH_TYPE_COW);
	}




	/*if (GetCanMorph(oTarget, POLYMORPH_TYPE_NYMPH)) {
	 * 	AddListItem(oPC, CT, "Nymphe (w)");
	 * 	SetListInt(oPC, CT, POLYMORPH_TYPE_NYMPH);
	 * }*/

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_TINY_FOREST) ) {
		AddListItem(oPC, CT, "kleine Waldviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_TINY_FOREST);
	}
	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_TINY_SWAMP) ) {
		AddListItem(oPC, CT, "kleine Sumpfviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_TINY_SWAMP);
	}
	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_TINY_JUNGLE) ) {
		AddListItem(oPC, CT, "kleine Jungelviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_TINY_JUNGLE);
	}
	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_TINY_DESERT) ) {
		AddListItem(oPC, CT, "kleine Wuestenviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_TINY_DESERT);
	}

	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_MED_FOREST) ) {
		AddListItem(oPC, CT, "mittlere Waldviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_MED_FOREST);
	}
	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_MED_SWAMP) ) {
		AddListItem(oPC, CT, "mittlere Sumpfviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_MED_SWAMP);
	}
	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_MED_JUNGLE) ) {
		AddListItem(oPC, CT, "mittlere Jungelviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_MED_JUNGLE);
	}
	if ( GetCanMorph(oTarget, POLYMORPH_TYPE_VIPER_MED_DESERT) ) {
		AddListItem(oPC, CT, "mittlere Wuestenviper");
		SetListInt(oPC, CT, POLYMORPH_TYPE_VIPER_MED_DESERT);
	}


	ResetConvList(oPC, oPC, CT, 50000, "s_polymorph_cb", HEAD);

	ClearAllActions(1);
	AssignCommand(oPC, ActionStartConversation(oPC, "list_select", 1, 0));
}



int GetCanMorph(object oTarget, int nPoly) {
	int nLevel = GetCasterLevel(OBJECT_SELF);

	switch ( nPoly ) {
		case POLYMORPH_TYPE_VIPER_MED_DESERT:
		case POLYMORPH_TYPE_VIPER_MED_JUNGLE:
		case POLYMORPH_TYPE_VIPER_MED_SWAMP:
		case POLYMORPH_TYPE_VIPER_MED_FOREST:
			return nLevel >= 6;

		case POLYMORPH_TYPE_GIANTEAGLE:
			return nLevel >= 10;

		case POLYMORPH_TYPE_WINTERWOLF:
			return nLevel >= 7;

		default:
			return nLevel >= 5;

			break;
	}

	return nLevel >= 5;
}

int GetHD(int nPoly) {

	//int nBonus = StringToInt(Get2DACached("polymorph", "HPBONUS", nPoly));

	switch ( nPoly ) {
		case POLYMORPH_TYPE_BADGER:
		case POLYMORPH_TYPE_BOAR:
		case POLYMORPH_TYPE_RAVEN:
			return 4;

		case POLYMORPH_TYPE_PIXIE:
			return 5;

		case POLYMORPH_TYPE_PANTHER:
			return 6;

	}

	return 4; // + (nBonus / 6);
}


/*
 *
 * void main() {
 * 	//Declare major variables
 * 	int nSpell = GetSpellId();
 * 	object oTarget = GetSpellTargetObject();
 * 	effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
 * 	effect ePoly;
 * 	int nPoly;
 *
 * 	//Determine Polymorph subradial type: Changed to disallow DIRE versions
 * 	switch (nSpell) {
 * 		case 401:
 * 			nPoly = POLYMORPH_TYPE_BROWN_BEAR;
 * 			break;
 * 		case 402:
 * 			nPoly = POLYMORPH_TYPE_PANTHER;
 * 			break;
 * 		case 403:
 * 			nPoly = POLYMORPH_TYPE_WOLF;
 * 			break;
 * 		case 404:
 * 			nPoly = POLYMORPH_TYPE_BOAR;
 * 			break;
 * 		case 405:
 * 			nPoly = POLYMORPH_TYPE_BADGER;
 * 			break;
 * 		default:
 * 			SendMessageToAllDMs("Code/hak-Bug: Unknown Spell-Id in Wildshape (for '" + GetName(OBJECT_SELF)+"'): " + IntToString(nSpell));
 * 			return;
 * 	}
 *
 * 	ePoly = SupernaturalEffect(EffectPolymorph(nPoly));
 *
 * 	//Fire cast spell at event for the specified target
 * 	// SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));
 * 	// Really, don't fire any event. We don't care.
 *
 * 	int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
 * 	int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
 * 	int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;
 *
 * 	object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
 * 	object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
 * 	object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
 * 	object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
 * 	object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
 * 	object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
 * 	object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
 * 	object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
 * 	object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
 * 	object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
 *
 *
 * 	if (GetIsObjectValid(oShield)) {
 * 		if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
 * 			GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
 * 			GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
 * 		{
 * 			oShield = OBJECT_INVALID;
 * 		}
 * 	}
 *
 *
 * 	ClearAllActions();
 * 	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
 * 	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF);
 *
 * 	// Now apply per-shape bona
 * 	switch (nPoly) {
 * 		case POLYMORPH_TYPE_BROWN_BEAR:
 * 			break;
 * 		case POLYMORPH_TYPE_PANTHER:
 * 			break;
 * 		case POLYMORPH_TYPE_WOLF:
 * 			break;
 * 		case POLYMORPH_TYPE_BOAR:
 * 			break;
 * 		case POLYMORPH_TYPE_BADGER:
 * 			break;
 * 	}
 *
 * 	object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
 * 	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
 *
 * 	if (bWeapon) {
 * 			IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
 * 	}
 *
 * 	if (bArmor) {
 * 		IPWildShapeCopyItemProperties(oShield,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
 * 	}
 *
 * 	if (bItems) {
 * 		IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
 * 	}
 *
 * }             */
