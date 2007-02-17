/* onSpawn: p_display.utc
 */

void main() {
	if ( !GetLocalInt(OBJECT_SELF, "has_p_vfx") ) {
		ApplyEffectToObject(DURATION_TYPE_PERMANENT,
			SupernaturalEffect(EffectVisualEffect(421)),
			OBJECT_SELF);
		SetLocalInt(OBJECT_SELF, "has_p_vfx", 1);
	}
}
