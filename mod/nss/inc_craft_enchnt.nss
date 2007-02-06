#include "inc_2dacache"

// Returns the XP costs to create a uncharged wand with nSpell
int GetXPCostForWandCreation(int nSpell, int nSpellCastLevel);

// Adds one charge to wand, if
// all throws are passed.
// 0 on failure, 1 on success.
int AddChargeToWand(object oCaster, object oWand, int nSpell);


int GetXPCostForWandCreation(int nSpell, int nSpellCastLevel) {
	int nItemCost = Get2DACached("iprp_spells", "Cost", nSpell);
	return nItemCost * nSpellCastLevel / 100;
}


int AddChargeToWand(object oCaster, object oWand, int nSpell) {

	int nSpellCast = -1;

	// find the spell

	itemproperty i = GetFirstItemProperty(oWand);
	while ( GetIsItemPropertyValid(i) ) {
		if ( GetItemPropertyType(i) ==  ITEM_PROPERTY_CAST_SPELL ) {
			nSpellCast = GetItemPropertySubType(i);
			break;
		}
		i = GetNextItemProperty(oWand);
	}

	if ( -1 == nSpellCast ) {
		// Wacky. No charge, or no wand.
		return 0;
	}

	return 1;
}
