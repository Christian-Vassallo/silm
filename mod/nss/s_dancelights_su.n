// Dancing light spawn script

void main() {
	object oLight = OBJECT_SELF;

	SetAssociateListenPatterns(oLight);

	int nLight = Random(7);
	nLight = nLight ==
			 0 ? VFX_DUR_LIGHT_BLUE_15 : nLight ==
			 1 ? VFX_DUR_LIGHT_GREY_15 : nLight == 2 ? VFX_DUR_LIGHT_ORANGE_15 :
			 nLight ==
			 3 ? VFX_DUR_LIGHT_PURPLE_15 : nLight ==
			 4 ? VFX_DUR_LIGHT_RED_15 : nLight == 5 ? VFX_DUR_LIGHT_WHITE_15 :
			 VFX_DUR_LIGHT_YELLOW_15;

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(100)), oLight);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(nLight)), oLight);
	SetLocalInt(oLight, "lightstate", 1);

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), oLight);
}
