/*
 * File: _events_itemdemo
 * A tag-execution based event system.
 * Copyright Bernard 'elven' Stoeckner.
 *
 * This code is licenced under the
 *  GNU/GPLv2 General Public Licence.
 */

/*
 * 	This is a DEMONSTRATION file. Copy
 * 	and edit to suit your needs.
 */

#include "inc_events"


void TransporterEffect(object oActivator, location oLocation, object oTarget = OBJECT_INVALID);

void main() {
	switch ( GetEvent() ) {
		case EVENT_ITEM_ACTIVATE:
			TransporterEffect(GetItemActivator(), GetItemActivatedTargetLocation(), GetItemActivatedTarget());
			break;
		case EVENT_ITEM_EQUIP:
			/* etc */
			break;
		case EVENT_ITEM_UNEQUIP:
			break;
		case EVENT_ITEM_ONHITCAST:
			break;
		case EVENT_ITEM_ACQUIRE:
			break;
		case EVENT_ITEM_UNACQUIRE:
			break;
		case EVENT_ITEM_SPELLCAST_AT:
			break;

		default: /* You might want to leave this stub intact,
				  *   for debugging purposes. */
			SendMessageToAllDMs("Warning in event system: Unhandled event.");
			SendMessageToAllDMs(" Script: " + GetTag(OBJECT_SELF));
			SendMessageToAllDMs(" Event : " + IntToString(GetEvent()));
			break;
	}

}

void TransporterEffect(object oActivator, location oLocation, object oTarget = OBJECT_INVALID) {
	SendMessageToPC(oActivator, "Transporter initiating.");

	vector v = GetPositionFromLocation(oLocation);
	SendMessageToPC(oActivator, " Target elevation vector: " + FloatToString(v.z));

	vector
	vFeet = v, vBody = v, vHead = v;
	vBody.z = vBody.z + 0.9;
	vHead.z = vBody.z + 0.9;

	location
	lFeet = Location(GetArea(oActivator), vFeet, 0.0),
	lBody = Location(GetArea(oActivator), vBody, 0.0),
	lHead = Location(GetArea(oActivator), vHead, 0.0);

	int size = CREATURE_SIZE_MEDIUM;
	if ( GetCreatureSize(oTarget) != CREATURE_SIZE_INVALID )
		size = GetCreatureSize(oTarget);
	else
		SendMessageToPC(oActivator, " Target object not found, forcing transport anyways.");

	SendMessageToPC(oActivator, " Target size: " +
		IntToString(size) + " out of (" + IntToString(CREATURE_SIZE_TINY) + "," +
		IntToString(CREATURE_SIZE_SMALL) +
		"," + IntToString(CREATURE_SIZE_MEDIUM) + "," + IntToString(CREATURE_SIZE_LARGE) + "," +
		IntToString(CREATURE_SIZE_HUGE) + ")");

	SendMessageToPC(oActivator, " Aquiring lock.");

	DelayCommand(0.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_IMP_SPELL_MANTLE_USE), oLocation));

	// feet
	DelayCommand(0.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lFeet));
	DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lFeet));
	DelayCommand(0.4, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lFeet));

	// body
	DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lBody));
	DelayCommand(0.4, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lBody));
	DelayCommand(0.6, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lBody));

	// head
	DelayCommand(0.4, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lHead));
	DelayCommand(0.6, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lHead));
	DelayCommand(0.8, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G),
			lHead));


	// nifty rings with cool whoop sound.
	DelayCommand(0.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			oLocation));
	DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			oLocation));
	DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			oLocation));
	DelayCommand(1.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			oLocation));

	DelayCommand(0.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			lHead));
	DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			lHead));
	DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			lHead));
	DelayCommand(1.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD),
			lHead));

	DelayCommand(2.5, SendMessageToPC(oActivator, "Transport complete."));
}
