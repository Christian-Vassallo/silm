#include "inc_currency"

void main() {

	object oPC = GetLastClosedBy();
	object oItem = GetFirstItemInInventory();
	int nGold = 0;

	while ( GetIsObjectValid(oItem) ) {

		// Holz
		if ( GetTag(oItem) == "CS_MA20" ) {
			nGold = nGold + 8;
			DestroyObject(oItem);
		}

		// Stein
		if ( GetTag(oItem) == "c_stone" ) {
			nGold = nGold + 11;
			DestroyObject(oItem);
		}

		// Eisenerz
		if ( GetTag(oItem) == "erz_eisen" ) {
			nGold = nGold + 65;
			DestroyObject(oItem);
		}

		// Veredeltes Eisen
		if ( GetTag(oItem) == "barren_stahl" ) {
			nGold = nGold + 120;
			DestroyObject(oItem);
		}

		oItem = GetNextItemInInventory();
	}

	//SendMessageToPC(oPC,IntToString(nGold));

	GiveValueToCreature(oPC, nGold);
}
