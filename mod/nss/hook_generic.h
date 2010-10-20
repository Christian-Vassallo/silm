#ifndef HOOK_GENERIC_H
#define HOOK_GENERIC_H

extern("hook_generic")

#define DestroyObject(...) Hook_DestroyObject(__VA_ARGS__)
#define CreateObject(...) Hook_CreateObject(__VA_ARGS__)
#define SetXP(...) Hook_SetXP(__VA_ARGS__)
#define GiveXPToCreature(...) Hook_GiveXPToCreature(__VA_ARGS__)
#define CopyItemAndModify(...) Hook_CopyItemAndModify(__VA_ARGS__)
#define CopyItem(...) Hook_CopyItem(__VA_ARGS__)

#define ActionJumpToObject(...) Hook_ActionJumpToObject(__VA_ARGS__)
#define ActionJumpToLocation(...) Hook_ActionJumpToLocation(__VA_ARGS__)
#define JumpToObject(...) Hook_JumpToObject(__VA_ARGS__)
#define JumpToLocation(...) Hook_JumpToLocation(__VA_ARGS__)

#define GetSpellTargetObject() Hook_GetSpellTargetObject()
#define GetSpellTargetLocation() Hook_GetSpellTargetLocation()
#define GetSpellCastItem() Hook_GetSpellCastItem()
#define GetMetaMagicFeat() Hook_GetMetaMagicFeat()
#define GetCasterLevel(...) Hook_GetCasterLevel(__VA_ARGS__)
#define GetSpellId() Hook_GetSpellId()
#define GetSpellSaveDC() Hook_GetSpellSaveDC()

#define ApplyEffectAtLocation(...) Hook_ApplyEffectAtLocation(__VA_ARGS__)
#define ApplyEffectToObject(...) Hook_ApplyEffectToObject(__VA_ARGS__)

#endif
