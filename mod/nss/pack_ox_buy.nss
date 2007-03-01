#include "inc_currency"
#include "inc_audit"

void main() {
	int iPrice = GetLocalInt(OBJECT_SELF, "PRICE");
	SetLocalInt(OBJECT_SELF, "OLD_PRICE", iPrice);
	DeleteLocalInt(OBJECT_SELF, "PRICE");

	TakeValueFromCreature(iPrice, GetPCSpeaker(), TRUE);
	ExecuteScript("pack_ox_tame", OBJECT_SELF);

	audit("buy", GetPCSpeaker(), audit_fields("vendor", GetTag(OBJECT_SELF)), "pack_ox");

	//Unregister pack animal from spawn system; allow trader to restock
	//if needed
	ExecuteScript("tms_death_spawn", OBJECT_SELF);
}
