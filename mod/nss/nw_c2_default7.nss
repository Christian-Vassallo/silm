//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
 * Default OnDeath event handler for NPCs.
 *
 * Adjusts killer's alignment if appropriate and
 * alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "x0_i0_spawncond"
#include "inc_xp_handling"
#include "inc_summon"

void _Respawn(int iObType, string sResRef, location lLocation) {
	CreateObject(iObType, sResRef, lLocation);
}

void main() {
	int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
	int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
	object oKiller = GetLastKiller();
	WriteTimestampedLogEntry(GetName(oKiller) + " toetet " + GetName(OBJECT_SELF));
	float fRespawnTime;

	// If we're a good/neutral commoner,
	// adjust the killer's alignment evil
	if ( nClass > 0 && ( nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL ) )
		AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);

	// Call to allies to let them know we're dead
	SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

	//Shout Attack my target, only works with the On Spawn In setup
	SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

	// NOTE: the OnDeath user-defined event does not
	// trigger reliably and should probably be removed
	if ( GetSpawnInCondition(NW_FLAG_DEATH_EVENT) ) {
		SignalEvent(OBJECT_SELF, EventUserDefined(1007));
	}

	if ( GetLocalInt(OBJECT_SELF, "summoncard") == TRUE ) {
		if ( GetIsObjectValid(ImprintCard(oKiller, OBJECT_SELF)) )
			FloatingTextStringOnCreature("Der Geist dieser Kreatur ist gefangen!", oKiller, FALSE);
	}

	if ( !GetLocalInt(OBJECT_SELF, "no_xp") )
		GiveKillXP();

	if ( ( fRespawnTime = GetLocalFloat(OBJECT_SELF, "RespawnTime") ) > 1.0f ) {
		int iObjType = GetObjectType(OBJECT_SELF);
		string sResRef = GetResRef(OBJECT_SELF);
		location lLocation = GetLocation(OBJECT_SELF);

		AssignCommand(GetModule(),
			DelayCommand(fRespawnTime,
				_Respawn(iObjType, sResRef, lLocation)));
	}

	if ( !GetLocalInt(OBJECT_SELF, "no_corpse") )
		ExecuteScript("corpse_death", OBJECT_SELF);

	if ( GetTag(OBJECT_SELF) == "ascore_ghost" ) {
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(SPELL_LESSER_DISPEL), GetLocation(
				OBJECT_SELF));
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), GetLocation(
				OBJECT_SELF));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisappear(1), OBJECT_SELF);
		DelayCommand(3.0, DestroyObject(OBJECT_SELF));
		return;
	}

}
