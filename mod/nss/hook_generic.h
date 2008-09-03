/*
File: hook_generic.h

This file hooks into some of the original function calls
and sends out events.

Hooked functions:
- DestroyObject - EVENT_TYPE_GLOBAL, EVENT_GLOBAL_OBJECT_DESTROY
- CreateObject - EVENT_TYPE_GLOBAL, EVENT_GLOBAL_OBJECT_CREATE
*/
#ifndef HOOK_GENERIC_H
#define HOOK_GENERIC_H

extern("hook_generic")

#define DestroyObject(...) Hook_DestroyObject(__VA_ARGS__)
#define CreateObject(...) Hook_CreateObject(__VA_ARGS__)
#define SetXP(...) Hook_SetXP(__VA_ARGS__)
#define GiveXPToCreature(...) Hook_GiveXPToCreature(__VA_ARGS__)

#define ActionJumpToObject(...) Hook_ActionJumpToObject(__VA_ARGS__)
#define ActionJumpToLocation(...) Hook_ActionJumpToLocation(__VA_ARGS__)
#define JumpToObject(...) Hook_JumpToObject(__VA_ARGS__)
#define JumpToLocation(...) Hook_JumpToLocation(__VA_ARGS__)

#endif
