#include "inc_corpse"

void Stun(object oPC) {
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 5.0);
}

object corpse_getconnectedbody(object oPlac) {
	object oPC;
	object oRealBody;

	/* Returns the old object if this isn't our corpse */
	if ( GetObjectType(oPlac) != OBJECT_TYPE_PLACEABLE
		|| GetTag(oPlac) != "BodyBag"
		|| !GetIsObjectValid(oRealBody = GetLocalObject(oPlac, "Body")) ) return OBJECT_INVALID;

	/*
	 * This is the fake corpse of the PC, go back another step
	 */
	if ( GetIsObjectValid(oPC = GetLocalObject(oRealBody, "PC_CORPSE")) ) return oPC;

	/*
	 * It is a soulless PC corpse, return the placeable as a failure notice
	 */
	if ( GetLocalInt(oRealBody, "WAS_PC_CORPSE") ) return OBJECT_INVALID;

	return oRealBody;
}

/*
 * Cleans up the Corpse placeable, destructs it and returns the original body
 * if there is something to resurrect
 */

object corpse_returnspirit(object oPlac) {
	object oRealBody;
	object oItem;

	oRealBody = corpse_getconnectedbody(oPlac);
	if ( !GetIsObjectValid(oRealBody) ) return oPlac; // Nothing to hook into.

	/*
	 * If we are about to revive a PC, pull him out of the nether plane and
	 * run the course on him, else simply remove the container placeable and
	 * let the critter stand up
	 */
	if ( GetIsObjectValid(GetLocalObject(oRealBody, "PC_CORPSE")) ) {
		ReIntegratePC(oRealBody);
		AssignCommand(oRealBody, ActionDoCommand(Stun(oRealBody)));
	} else {
		AssignCommand(oRealBody, SetIsDestroyable(FALSE, TRUE, TRUE));

		oItem = GetFirstItemInInventory(oPlac);
		while ( GetIsObjectValid(oItem) ) {
			DestroyObject(oItem);
			oItem = GetNextItemInInventory(oPlac);
		}
		DestroyObject(oPlac);
	}
	return oRealBody;
}


//void main() { }
