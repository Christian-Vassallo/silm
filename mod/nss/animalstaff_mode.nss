void main() {
	object oPC = GetPCSpeaker();
	object oComp = GetLocalObject(oPC, "animalstaff_comp");
	location lTarget = GetLocalLocation(oPC, "animalstaff_targetl");
	object oTarget = GetLocalObject(oPC, "animalstaff_target");

	if ( !GetIsObjectValid(oComp) ) {
		SendMessageToPC(oPC, "Ihr benötigt einen Tiergefährten, um diesen Stab benutzen zu können.");
		return;
	}

	SetActionMode(oComp, ACTION_MODE_STEALTH, !GetActionMode(oComp, ACTION_MODE_STEALTH));
}
