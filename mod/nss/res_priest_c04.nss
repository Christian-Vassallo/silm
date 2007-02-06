#include "corpse_raise"

int StartingConditional() {
	int iPrice;

	if ( GetLocalInt(OBJECT_SELF, "NO_HEAL") ) return FALSE;

	iPrice = GetHitDice(GetPCSpeaker()) * 10;
	SetCustomToken(35000, IntToString(iPrice / 10));
	SetCustomToken(35001, GetDeity(OBJECT_SELF));
	SetLocalInt(OBJECT_SELF, "CURRENT_PRICE", iPrice);

	return TRUE;
}
