// The Feuerwerk bottle item

#include "_events"

void Feuerwerk(object f);

void main() {
	switch ( GetEvent() ) {
		case EVENT_ITEM_ACTIVATE:
			/* Here be code to handle Item Activation */
			break;
		case EVENT_ITEM_EQUIP:
			/* etc */
			break;
		case EVENT_ITEM_UNEQUIP:
			break;
		case EVENT_ITEM_ONHITCAST:
			break;
		case EVENT_ITEM_ACQUIRE:
			SetLocalInt(OBJECT_SELF, "stopfeuer", 1);
			break;
		case EVENT_ITEM_UNACQUIRE:
			SetLocalInt(OBJECT_SELF, "stopfeuer", 0);
			// die werden nicht angezeigt - macht aber nix
			DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
						VFX_COM_BLOOD_SPARK_LARGE), OBJECT_SELF));
			DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
						VFX_COM_HIT_DIVINE), OBJECT_SELF));
			DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
						VFX_COM_HIT_DIVINE), OBJECT_SELF));
			DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
						VFX_COM_HIT_DIVINE), OBJECT_SELF));
			DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(
						VFX_COM_HIT_NEGATIVE), OBJECT_SELF));
			DelayCommand(6.0, Feuerwerk(OBJECT_SELF));
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



void Feuerwerk(object f) {
	if ( GetLocalInt(f, "stopfeuer") == 1 )  //picked up
		return;

	location lo = GetLocation(f);
	DestroyObject(f);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_IMPLOSION), lo, 5.0);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_BLINDDEAF), lo, 5.0);
	DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(
				VFX_FNF_DISPEL_DISJUNCTION), lo, 5.0));
	DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY),
			lo, 5.0));
	DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(
				VFX_FNF_DISPEL_GREATER), lo, 5.0));
	DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_FIREBALL,
				TRUE), lo, 5.0));
	DelayCommand(6.2, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_FIREBALL,
				TRUE), lo, 5.0));
	DelayCommand(6.4, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_FIREBALL,
				TRUE), lo, 5.0));

}

