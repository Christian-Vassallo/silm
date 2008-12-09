#ifndef ALIASES_H
#define ALIASES_H

// Macro: atoi(s)
// Convert a string to an integer
#define atoi(s) StringToInt(s)
// Macro: itoa(i)
// Convert a integer to a string
#define itoa(i) IntToString(i)
// Macro: ftoa(f)
// Converts a flaot to a string
#define ftoa(f) FloatToString(f)
// Macro: atof(s)
// Converts a string to a float
#define atof(s) StringToFloat(s)
// Macro: ftoi(f)
// Casts a float to a int
#define ftoi(f) FloatToInt(f)
// Macro: itof(u)
// Cast a int to a float
#define itof(i) IntToFloat(i)

// Macro: otoa(o)
// Converts a object into a human-readable format
#define otoa(o) (GetIsObjectValid(o) ? ("#" + \
	ObjectToString(o) + \
	"{" + \
		IntToString(GetObjectType(o)) + "," + \
		GetResRef(o) + "," + \
		GetTag(o) + "," + \
		"[" + (is_client(o) ? (itoa(GetAccountID(o)) + "," + itoa(GetCharacterID(o))) : itoa(p_get_p_id(o))) + "]," + \
		GetName(o) + \
	"}") \
: "OBJECT_INVALID")

// Macro: is_valid)o)
// GetIsObjectValid(o)
#define is_valid(o) GetIsObjectValid(o)
// Macro: is_item(o)
// (GetObjectType(o) == OBJECT_TYPE_ITEM)
#define is_item(o) (GetObjectType(o) == OBJECT_TYPE_ITEM)
// Macro: is_creature(o)
// (GetObjectType(o) == OBJECT_TYPE_CREATURE)
#define is_creature(o) (GetObjectType(o) == OBJECT_TYPE_CREATURE)
// Macro: is_placeable(o)
// (GetObjectType(o) == OBJECT_TYPE_PLACEABLE)
#define is_placeable(o) (GetObjectType(o) == OBJECT_TYPE_PLACEABLE)
// Macro: is_door(o)
// (GetObjectType(o) == OBJECT_TYPE_DOOR)
#define is_door(o) (GetObjectType(o) == OBJECT_TYPE_DOOR)
// Macro: is_trigger(o)
// (GetObjectType(o) == OBJECT_TYPE_TRIGGER)
#define is_trigger(o) (GetObjectType(o) == OBJECT_TYPE_TRIGGER)
// Macro: is_encounter(o)
// (GetObjectType(o) == OBJECT_TYPE_ENCOUNTER)
#define is_encounter(o) (GetObjectType(o) == OBJECT_TYPE_ENCOUNTER)
// Macro: is_store(o)
// (GetObjectType(o) == OBJECT_TYPE_STORE)
#define is_store(o) (GetObjectType(o) == OBJECT_TYPE_STORE)
// Macro: is_waypoint(o)
// (GetObjectType(o) == OBJECT_TYPE_WAYPOINT)
#define is_waypoint(o) (GetObjectType(o) == OBJECT_TYPE_WAYPOINT)
// Macro: is_aoe(o)
// (GetObjectType(o) == OBJECT_TYPE_AREA_OF_EFFECT)
#define is_aoe(o) (GetObjectType(o) == OBJECT_TYPE_AREA_OF_EFFECT)
// Macro: is_area(o)
// (is_valid(o) && GetObjectType(o) == OBJECT_TYPE_ALL)
#define is_area(o) (is_valid(o) && GetObjectType(o) == OBJECT_TYPE_ALL)
// Macro: is_client(o)
// GetIsPC(o)
#define is_client(o) GetIsPC(o)
// Macro: is_pc(o)
// GetIsPC(o) && !GetIsDM(o)
#define is_pc(o) (GetIsPC(o) && !GetIsDM(o))
// Macro: is_dm(o)
// GetIsDM(o)
#define is_dm(o) GetIsDM(o)

#define is_class(o,c) (GetClassByPosition(1) == c || GetClassByPosition(2) == c ||·GetClassByPosition(3) == c)
#define is_barbarian(o) is_class(o,CLASS_TYPE_BARBARIAN)
#define is_bard(o) is_class(o,CLASS_TYPE_BARD)
#define is_cleric(o) is_class(o,CLASS_TYPE_CLERIC)
#define is_druid(o) is_class(o,CLASS_TYPE_DRUID)
#define is_fighter(o) is_class(o,CLASS_TYPE_FIGHTER)
#define is_monk(o) is_class(o,CLASS_TYPE_MONK)
#define is_paladin(o) is_class(o,CLASS_TYPE_PALADIN)
#define is_ranger(o) is_class(o,CLASS_TYPE_RANGER)
#define is_rogue(o) is_class(o,CLASS_TYPE_ROGUE)
#define is_sorcerer(o) is_class(o,CLASS_TYPE_SORCERER)
#define is_wizard(o) is_class(o,CLASS_TYPE_WIZARD)
#define is_aberration(o) is_class(o,CLASS_TYPE_ABERRATION)
#define is_animal(o) is_class(o,CLASS_TYPE_ANIMAL)
#define is_construct(o) is_class(o,CLASS_TYPE_CONSTRUCT)
#define is_humanoid(o) is_class(o,CLASS_TYPE_HUMANOID)
#define is_monstrous(o) is_class(o,CLASS_TYPE_MONSTROUS)
#define is_elemental(o) is_class(o,CLASS_TYPE_ELEMENTAL)
#define is_fey(o) is_class(o,CLASS_TYPE_FEY)
#define is_dragon(o) is_class(o,CLASS_TYPE_DRAGON)
#define is_undead(o) is_class(o,CLASS_TYPE_UNDEAD)
#define is_commoner(o) is_class(o,CLASS_TYPE_COMMONER)
#define is_beast(o) is_class(o,CLASS_TYPE_BEAST)
#define is_giant(o) is_class(o,CLASS_TYPE_GIANT)
#define is_magical_beast(o) is_class(o,CLASS_TYPE_MAGICAL_BEAST)
#define is_outsider(o) is_class(o,CLASS_TYPE_OUTSIDER)
#define is_shapechanger(o) is_class(o,CLASS_TYPE_SHAPECHANGER)
#define is_vermin(o) is_class(o,CLASS_TYPE_VERMIN)
#define is_shadowdancer(o) is_class(o,CLASS_TYPE_SHADOWDANCER)
#define is_harper(o) is_class(o,CLASS_TYPE_HARPER)
#define is_arcane_archer(o) is_class(o,CLASS_TYPE_ARCANE_ARCHER)
#define is_assassin(o) is_class(o,CLASS_TYPE_ASSASSIN)
#define is_blackguard(o) is_class(o,CLASS_TYPE_BLACKGUARD)
#define is_divinechampion(o) is_class(o,CLASS_TYPE_DIVINECHAMPION)
#define is_divine_champion(o) is_class(o,CLASS_TYPE_DIVINE_CHAMPION)
#define is_weapon_master(o) is_class(o,CLASS_TYPE_WEAPON_MASTER)
#define is_palemaster(o) is_class(o,CLASS_TYPE_PALEMASTER)
#define is_pale_master(o) is_class(o,CLASS_TYPE_PALE_MASTER)
#define is_shifter(o) is_class(o,CLASS_TYPE_SHIFTER)
#define is_dwarvendefender(o) is_class(o,CLASS_TYPE_DWARVENDEFENDER)
#define is_dwarven_defender(o) is_class(o,CLASS_TYPE_DWARVEN_DEFENDER)
#define is_dragondisciple(o) is_class(o,CLASS_TYPE_DRAGONDISCIPLE)
#define is_dragon_disciple(o) is_class(o,CLASS_TYPE_DRAGON_DISCIPLE)
#define is_ooze(o) is_class(o,CLASS_TYPE_OOZE)
#define is_eye_of_gruumsh(o) is_class(o,CLASS_TYPE_EYE_OF_GRUUMSH)
#define is_shou_disciple(o) is_class(o,CLASS_TYPE_SHOU_DISCIPLE)
#define is_purple_dragon_knight(o) is_class(o,CLASS_TYPE_PURPLE_DRAGON_KNIGHT)


#define lv_i(o,n) GetLocalInt(o,n)
#define slv_i(o,n,v) SetLocalInt(o,n,v)
#define dlv_i(o,n) DeleteLocalInt(o,n)

#endif
