#include "inc_corpse"
#include "inc_xp_handling"

void main() {
	object oClicker = GetClickingObject();
	object oTarget = GetTransitionTarget(OBJECT_SELF);

	SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
	if ( GetIsPC(oClicker) ) {
		ReincarnatePC(oClicker);
		XP_LoseXP(oClicker, GetLegacyPersistentInt(oClicker, "PC_XP_PENALTY"));
		SetLegacyPersistentInt(oClicker, "PC_XP_PENALTY", 0);
	}
	//FIXME: RespawnTarget
	AssignCommand(oClicker, JumpToObject(GetObjectByTag("RESPAWN_LOC")));
}
