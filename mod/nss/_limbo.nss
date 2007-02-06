const string
LIMBO_WAYPOINT = "wp_sclimbo";


// Puts a creature into scriptlimbo. Forces. No queueing.
int Limbo(object oObj, int bAction = FALSE, int bCommandFix = FALSE);

// Same as Limbo but as Action.
int ActionLimbo(object oObj);


// Removes a  creature from scriptlimbo, returning
// it where it was before it got sent to limbo.
int Unlimbo(object oObj, int bAction = FALSE, int bCommandFix = FALSE);

// Returns TRUE if oObj is currently in scriptlimbo.
int IsLimbo(object oObj);

int Limbo(object oObj, int bAction = FALSE, int bCommandFix = FALSE) {
	if ( !GetIsObjectValid(oObj) )
		return FALSE;

	object lLimbo = GetObjectByTag("wp_sclimbo");
	if ( !GetIsObjectValid(lLimbo) || !GetIsObjectValid(oObj) )
		return FALSE;

	if ( GetMaxHitPoints(oObj) != 0 ) {
		/* creature */
		SetLocalInt(oObj, "limbo", 1);
		SetLocalLocation(oObj, "limbo_location", GetLocation(oObj));
		if ( bAction ) {
			AssignCommand(oObj, ActionJumpToObject(lLimbo));
		} else {
			AssignCommand(oObj, ClearAllActions(1));
			AssignCommand(oObj, JumpToObject(lLimbo));
		}
		if ( bCommandFix )
			SetCommandable(FALSE, oObj);
	} else {
		/* item */
		return FALSE;
	}
	return TRUE;
}


int Unlimbo(object oObj, int bAction = FALSE, int bCommandFix = FALSE) {
	if ( !GetIsObjectValid(oObj) )
		return FALSE;

	if ( GetMaxHitPoints(oObj) != 0 ) {
		/* creature */
		if ( !GetLocalInt(oObj, "limbo") )
			return FALSE;

		location lX = GetLocalLocation(oObj, "limbo_location");
		DeleteLocalInt(oObj, "limbo");
		DeleteLocalLocation(oObj, "limbo_location");

		if ( bAction ) {
			AssignCommand(oObj, ActionJumpToLocation(lX));
		} else {
			AssignCommand(oObj, ClearAllActions(1));
			AssignCommand(oObj, JumpToLocation(lX));
		}
		if ( bCommandFix )
			SetCommandable(TRUE, oObj);

	} else {
		/* item */
		return FALSE;
	}

	return TRUE;
}

int IsLimbo(object oObj) {
	return 1 == GetLocalInt(oObj, "limbo");
}
