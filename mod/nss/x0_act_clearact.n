// * just used to clear all actions at end of dialog when needed
#include "x2_inc_craft"
#include "inc_customize"
void main() {
	ClearAllActions();

	Assert_Copy_Destroyed(OBJECT_SELF, INVENTORY_SLOT_CHEST);
	Assert_Copy_Destroyed(OBJECT_SELF, INVENTORY_SLOT_RIGHTHAND);
}
