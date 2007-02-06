#include "inc_xp_handling"

void main() {
	object oPC = GetLastUsedBy();
	object oOb = GetItemPossessedBy(oPC, "WF_WATER");

	if ( GetIsObjectValid(oOb) ) {
		DestroyObject(oOb);
		SendMessageToPC(oPC, "Mit dem Eimer Wasser loeschst Du die Flammen.");
		XP_RewardQuestXP(oPC, 20);
		DelayCommand(0.2f, DestroyObject(OBJECT_SELF));
		return;
	}

	SendMessageToPC(oPC,
		"Ohne Wasser kannst Du nur die Erde um das Feuer umschaufeln und so versuchen das Feuer zu ersticken!");
}

