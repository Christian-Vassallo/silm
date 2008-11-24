// Macro: GetVisualEffectId
//
// Returns the visual effect ID of the given effect.
// Depends on inc_nwnx_structs.
#define GetVisualEffectId(effect) (GetEffectType(effect) == EFFECT_TYPE_VISUALEFFECT ? GetEffectInteger(effect, 0) : -1)
