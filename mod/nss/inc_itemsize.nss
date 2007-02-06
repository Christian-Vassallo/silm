/* inc item size */

#include "inc_2dacache"





// Returns the item size of the given object in inventory tiles.
int GetItemSize(object oItem);


// Returns the total size of all items in oInv.
int GetTotalContainerItemSizeSum(object oInv);


// aa..a..a..aaaa.a.. :)
// .... a.....a...d.@...

int GetItemSize(object oItem) {
	int nBaseItem = GetBaseItemType(oItem);
	if ( BASE_ITEM_INVALID == nBaseItem )
		return 0;

	int nX = StringToInt(Get2DACached("baseitems", "InvSlotWidth", nBaseItem));
	int nY = StringToInt(Get2DACached("baseitems", "InvSlotHeight", nBaseItem));

	int ret = nX * nY;
	if ( GetItemStackSize(oItem) > 1 )
		ret *= GetItemStackSize(oItem);
	return ret;
}





int GetTotalContainerItemSizeSum(object oInv) {
	int total = 0;
	object o = GetFirstItemInInventory(oInv);
	while ( GetIsObjectValid(o) ) {
		total += GetItemSize(o);
		o = GetNextItemInInventory(oInv);
	}
	return total;
}
