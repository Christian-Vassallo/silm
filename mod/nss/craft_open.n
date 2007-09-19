#include "inc_craft"

void main() {
	object oPC = GetLastOpenedBy();

	OnOpen(oPC, OBJECT_SELF);

}
