void main() {
	object oPC = GetClickingObject();
	object oTarget = GetWaypointByTag("ws_eskarith");

	object oRope = GetObjectByTag("s_eskarith");

	if ( !GetIsObjectValid(oRope) ) {
		object oNewRope = CreateObject(OBJECT_TYPE_PLACEABLE, "strickleiter", GetLocation(oTarget), FALSE,
							  "s_eskarith");
		if ( !GetIsObjectValid(oNewRope) ) {
			SendMessageToPC(oPC, "Cannot spawn rope :/");
			return;
		}
		SetLocalString(oNewRope, "target", "wst_eskarith");

		FloatingTextStringOnCreature("Du laesst die Strickleiter herab.", oPC, TRUE);
	}

	FloatingTextStringOnCreature("Du kletterst die Strickleiter hinab ..", oPC, FALSE);
	DelayCommand(4.0, AssignCommand(oPC, JumpToObject(oTarget)));
}
