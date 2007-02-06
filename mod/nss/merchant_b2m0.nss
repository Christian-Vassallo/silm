#include "inc_merchant"
#include "inc_lists"

void main() {
	object oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC");
	DeleteLocalInt(oPC, TTT + "_m0");

	// SendMessageToPC(oPC, "Back to menue.");

	MakeMerchantDialog(oPC, OBJECT_SELF);
}
