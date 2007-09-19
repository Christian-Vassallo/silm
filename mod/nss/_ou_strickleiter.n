void main() {
	object oLeiter = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	string sTarget = GetLocalString(oLeiter, "target");

	object oWP = GetWaypointByTag(sTarget);

	if ( !GetIsObjectValid(oWP) ) {
		SendMessageToPC(oPC, "Diese Strickleiter hat kein gueltiges Ziel. (bug)");
		return;
	}


	FloatingTextStringOnCreature("Du kletterst die Strickleiter hinauf ..", oPC, FALSE);
	DelayCommand(4.0, AssignCommand(oPC, JumpToObject(oWP)));

}
