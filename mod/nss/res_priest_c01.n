#include "corpse_raise"

int StartingConditional() {
	object oCorpse = GetNearestObjectByTag("BodyBag");
	object oTarget;
	int iPrice;

	if ( GetLocalInt(OBJECT_SELF, "NO_RESURRECT") ) return FALSE;

	if ( !GetIsObjectValid(oCorpse) ) return FALSE;

	if ( GetArea(OBJECT_SELF) != GetArea(oCorpse) ) return FALSE;

	if ( GetDistanceBetween(oCorpse, OBJECT_SELF) > 6.0f ) return FALSE;

	if ( !GetIsObjectValid(oTarget = corpse_getconnectedbody(oCorpse)) ) return FALSE;


	SetLocalObject(OBJECT_SELF, "CURRENT_CORPSE", oCorpse);
	SetLocalObject(OBJECT_SELF, "CURRENT_TARGET", oTarget);

	iPrice = GetHitDice(oTarget) * 50;
	SetCustomToken(35000, IntToString(iPrice / 100));
	SetCustomToken(35001, GetDeity(OBJECT_SELF));
	SetLocalInt(OBJECT_SELF, "CURRENT_PRICE", iPrice);

	return TRUE;
}
