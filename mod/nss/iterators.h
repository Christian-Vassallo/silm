#ifndef ITERATORS_H
#define ITERATORS_H

// Macro: iterate_valid_effect(effect,inline_code)
#define iterate_valid_effect(effect,inline_code) __EBLOCK(\
	while (GetIsEffectValid(effect)) { \
		inline_code; \
	})

// Macro: iterate_valid_object(effect,inline_code)
#define iterate_valid_object(object,inline_code) __EBLOCK(\
	while (GetIsObjectValid(object)) { \
		inline_code; \
	})

// Macro: iterate_type_sequential_conditional(type,start,cont,check,varname,inline_code)
#define iterate_type_sequential_conditional(type,start,cont,check,varname,inline_code) __EBLOCK(\
	type varname = start; \
	while (check) { \
		inline_code; \
		varname = cont; \
	})

// Macro: iterate_valid_object_sequential(start,cont,varname,inline_code)
#define iterate_valid_object_sequential(start,cont,varname,inline_code) __EBLOCK( \
	object varname = start; \
	iterate_valid_object(varname, inline_code; varname = cont);)

// Macro: iterate_near_object(object_type,near_to,varname,inline_code)
#define iterate_near_object(object_type,near_to,varname,inline_code) __EBLOCK(\
	object varname = GetNearestObject(object_type, near_to, 1); int iter = 1; \
	iterate_valid_object(varname, \
		inline_code; varname = GetNearestObject(object_type,near_to,++iter); \
	); \
)

/* Macro: iterate_players(varname,inline_code)
 * Iterates through all players
 */
#define iterate_players(varname,inline_code) iterate_valid_object_sequential(GetFirstPC(),GetNextPC(),varname,inline_code)

/* Macro: iterate_inventory(object,varname,inline_code)
 * Iterates through an objects' inventory.
 */
#define iterate_inventory(object,varname,inline_code) iterate_valid_object_sequential(GetFirstItemInInventory(object),GetNextItemInInventory(object),varname,inline_code)

/* Macro: iterate_equipped(object,slotvarname,varname,inline_code)
 * Iterates over all equipped items.
 */
#define iterate_equipped(on_object,slotvarname,varname,inline_code) __EBLOCK(object varname;int slotvarname;for(slotvarname = 0; slotvarname < NUM_INVENTORY_SLOTS; slotvarname++) { varname = GetItemInSlot(slotvarname, on_object); inline_code; })

/* Macro: iterate_equipped_and_inventory(object,varname,inline_code)
 * Iterates over all equipped items, and then over the rest of objects' inventory.
 */
#define iterate_equipped_and_inventory(object,varname,inline_code) iterate_equipped(object,nSlot,varname,inline_code);iterate_inventory(object,varname,inline_code)

/* Macro: iterate_effects(on_object,varname,inline_code)
 * Iterates through all effects on a given object.
 */
#define iterate_effects(on_object,varname,inline_code) iterate_type_sequential_conditional(effect,GetFirstEffect(on_object),GetNextEffect(on_object),GetIsEffectValid(varname),varname,inline_code)

/* Macro: iterate_iprp(on_object,varname,inline_code)
 * Iterates through all item propertys on a given item.
 */
#define iterate_iprp(on_object,varname,inline_code) iterate_type_sequential_conditional(itemproperty,GetFirstItemProperty(on_object),GetNextItemProperty(on_object),GetIsItemPropertyValid(varname),varname,inline_code)

/* Macro: iterate_area(area,varname,inline_code)
 * Iterates through all objects in this area.
 */
#define iterate_area(area,varname,inline_code) iterate_valid_object_sequential(GetFirstObjectInArea(area),GetNextObjectInArea(area),varname,inline_code)

#endif
