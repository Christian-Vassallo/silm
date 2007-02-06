#include "inc_customize"

void main() {
	Assert_Copy_Destroyed(GetPCSpeaker(), INVENTORY_SLOT_CHEST);
	Assert_Copy_Destroyed(GetPCSpeaker(), INVENTORY_SLOT_RIGHTHAND);
	SetLocalInt(GetPCSpeaker(), "noclothchange", 0);
}
