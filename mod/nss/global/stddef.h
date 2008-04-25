#ifndef STDDEF_H
#define STDDEF_H

#define true TRUE
#define false FALSE

#define bool int

#define xstr(s) str(s)
#define str(s) #s

#define __LINE #line
#define __FILE #file

// Macro: __EBLOCK(code)
// Localized block-wrapper
#define __EBLOCK(x) do { x } while(0)

#define local(x) __EBLOCK(x)

#define queue(obj,diff,action) AssignCommand(obj,DelayCommand(diff,action))

// Macro: iterate_valid_effect(effect,inline_code)
#define iterate_valid_effect(effect,inline_code) \
	while (GetIsEffectValid(effect)) { \
		inline_code; \
	}

// Macro: iterate_valid_object(effect,inline_code)
#define iterate_valid_object(object,inline_code) \
	while (GetIsObjectValid(object)) { \
		inline_code; \
	}

// Macro: iterate_type_sequential_conditional(type,start,cont,check,inline_code)
#define iterate_type_sequential_conditional(type,start,cont,check,inline_code) \
	type oIterate = start; \
	while (check) { \
		inline_code; \
		oIterate = cont; \
	}

// Macro: iterate_valid_object_sequential(start,cont,inline_code)
#define iterate_valid_object_sequential(start,cont,inline_code) \
	object oIterate = start; \
	iterate_valid_object(oIterate, inline_code; oIterate = cont);

// Macro: iterate_near_object(object_type,near_to,inline_code)
#define iterate_near_object(object_type,near_to,inline_code) __EBLOCK(\
	object oIterate = GetNearestObject(object_type, near_to, 1); int iter = 1; \
	iterate_valid_object(oIterate, \
		inline_code; oIterate = GetNearestObject(object_type,near_to,++iter); \
	); \
)



/* Macro: iterate_players(inline_code)
 * Iterates through all players
 */
#define iterate_players(inline_code) iterate_valid_object_sequential(GetFirstPC(),GetNextPC(),inline_code)

/* Macro: iterate_inventory(object,inline_code)
 * Iterates through an objects' inventory.
 */
#define iterate_inventory(object,inline_code) iterate_valid_object_sequential(GetFirstItemInInventory(object),GetNextItemInInventory(object),inline_code)

/* Macro: iterate_effects(on_object,inline_code)
 * Iterates through all effects on a given object.
 */
#define iterate_effects(on_object,inline_code) iterate_type_sequential_conditional(effect,GetFirstEffect(on_object),GetNextEffect(on_object),GetIsEffectValid(oIterate),inline_code)


/* Macro: iterate_area(area,inline_code)
 * Iterates through all objects in this area.
 */
#define iterate_area(area,inline_code) iterate_valid_object_sequential(GetFirstObjectInArea(area),GetNextObjectInArea(area),inline_code)

#include "git.h"
#include "log.h"
#include "inline.h"
#include "mutex.h"
#include "string.h"
#include "events.h"

#endif
