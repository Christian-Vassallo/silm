#include "inc_currency"
#include "inc_persist"
void main() {
	int iValue, iGoldSum;

	//Let PC start out at level 2, look after starting equipment
	if ( !GetXP(OBJECT_SELF) && !GetIsDM(OBJECT_SELF) ) {
		object oItem = GetFirstItemInInventory(OBJECT_SELF);

		SetXP(OBJECT_SELF, 6000);
		while ( GetIsObjectValid(oItem) ) {
			iGoldSum += GetGoldPieceValue(oItem);
			DestroyObject(oItem);
			oItem = GetNextItemInInventory(OBJECT_SELF);
		}
		//Convert the starting money and pay a compensation for the
		//items destroyed.
		iValue = GetGold(OBJECT_SELF);
		TakeGoldFromCreature(iValue, OBJECT_SELF, TRUE);
		GiveValueToCreature(OBJECT_SELF, iValue * 100 + iGoldSum);

	}

}
