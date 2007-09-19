#include "inc_currency"

int MAX_ITEM_COUNT = 1;
int MAX_TOTAL_COUNT = 100;

/* Heartbeat function: Convert the numerical value back into items as soon the store is left */
void _Store_HB(object oPC) {
	/* Logged out/crashed */
	if ( !GetIsObjectValid(oPC) ) return;

	if ( GetDistanceBetween(oPC, OBJECT_SELF) > 5.0f ) {
		int iValue = GetGold(oPC);
		GiveValueToCreature(oPC, iValue);
		TakeGoldFromCreature(iValue, oPC, TRUE);
		return;
	}

	DelayCommand(2.0f, _Store_HB(oPC));
}

void TagStoreInventory() {
	object oItem = GetFirstItemInInventory();
	while ( GetIsObjectValid(oItem) ) {
		SetLocalInt(oItem, "TMS_STORE_GENUINE", 1);
		oItem = GetNextItemInInventory();
	}
}

void PruneStoreInventory() {
	int iItemCount;
	int iTotalCount;
	object oItm;
	string sTag;

	oItm = GetFirstItemInInventory();
	while ( GetIsObjectValid(oItm) ) {
		if ( !GetLocalInt(oItm, "TMS_STORE_GENUINE") ) {
			sTag = GetTag(oItm);
			iItemCount = GetLocalInt(OBJECT_SELF, "count_" + sTag);
			if ( iItemCount > MAX_ITEM_COUNT || iTotalCount > MAX_TOTAL_COUNT )
				DestroyObject(oItm);
			else {
				SetLocalInt(OBJECT_SELF, "count_" + sTag, iItemCount + 1);
				iTotalCount++;
			}
		}
		oItm = GetNextItemInInventory();
	}

	oItm = GetFirstItemInInventory();
	while ( GetIsObjectValid(oItm) ) {
		DeleteLocalInt(OBJECT_SELF, "count_" + GetTag(oItm));
		oItm = GetNextItemInInventory();
	}
}

void main() {
	object oPC = GetLastOpenedBy();

	/* Convert the money into the gold piece value */
	GiveGoldToCreature(oPC, Money2Value(CountCreatureMoney(oPC, TRUE)));

	if ( !GetLocalInt(OBJECT_SELF, "Store_Initialized") ) {
		TagStoreInventory();
		SetLocalInt(OBJECT_SELF, "Store_Initialized", 1);
	} else
		PruneStoreInventory();

	DelayCommand(2.0f, _Store_HB(oPC));
}

