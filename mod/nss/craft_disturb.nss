#include "inc_craft"

void main() {
	object oItem = GetInventoryDisturbItem();
	object oPC = GetLastDisturbed();

	int nType = GetInventoryDisturbType();

	OnDisturb(oPC, OBJECT_SELF, oItem, nType);
}
