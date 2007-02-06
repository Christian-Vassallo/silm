#include "inc_currency"

void main() {
	object oPC = GetPCSpeaker();

	TakeValueFromCreature(GetLocalInt(oPC, "SPECIAL_PRICE") * 100, oPC, TRUE);

}
