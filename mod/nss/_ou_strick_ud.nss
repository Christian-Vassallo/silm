void main() {
	object oPC = GetLastUsedBy();

	string sTargetTag = GetLocalString(OBJECT_SELF, "target_rope");

	object oTargetLoc = GetWaypointByTag("w" + sTargetTag);

	object oRope = GetObjectByTag(sTargetTag);

	if ( !GetIsObjectValid(oTargetLoc) ) {
		SendMessageToPC(oPC, "Invalid target (bug)");
		return;
	}

	if ( !GetIsObjectValid(oRope) ) {
		object oNewRope = CreateObject(OBJECT_TYPE_PLACEABLE, "strickleiter", GetLocation(oTargetLoc), FALSE,
							  sTargetTag);
		if ( !GetIsObjectValid(oNewRope) ) {
			SendMessageToPC(oPC, "Cannot spawn rope :/");
			return;
		}
		SetLocalString(oNewRope, "target", "wst_eskarith");

		FloatingTextStringOnCreature("Du laesst die Strickleiter herab.", oPC, TRUE);
	} else {
		DestroyObject(oRope);
		FloatingTextStringOnCreature("Du ziehst die Strickleiter hoch.", oPC, TRUE);
	}
}
