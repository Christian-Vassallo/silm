#include "inc_bodyparts"

void main() {
	object oPC = GetPCSpeaker();
	DeleteLocalInt(oPC, "BODY_SEL_PART");
	MakeDialog(oPC);
	ActionStartConversation(oPC, "list_select", TRUE, FALSE);
}
