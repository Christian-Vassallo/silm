#ifndef INLINE_H
#define INLINE_H

#define MODULE GetModule()

#define MINUTES_PER_HOUR FloatToInt(HoursToSeconds(1)/60)
#define GetMinutesPerHour() MINUTES_PER_HOUR

// Macro: GetPCName(o)
// Returns the player name of o, even if o is in the process of logging out
#define GetPCName(o) (GetPCPlayerName(o)==""?GetLocalString(o,"player_name"):GetPCPlayerName(o))

// Macro: StringToBool(s)
// Converts strings to an appropriate boolean value.
#define StringToBool(s) (s=="true"||s=="yes"||s=="y"||s=="t"||StringToInt(s)!=0)

// Macro: BoolToString(b)
// Converts boolean values to a string.
#define BoolToString(b)	(b>0?"true":"false")

// Macro: exch(x,y)
// Swaps x and y of type int
#define exch(x,y) __EBLOCK(int tmp; tmp=x; x=y; y=tmp;)

// Macro: txch(t,x,y)
// Swaps x and y of typeclass t
#define xch(t,x,y) __EBLOCK(t tmp; tmp=x; x=y; y=tmp;)

// Macro: clamp(n,min,max)
// Clamps numeric value n between min and max
#define clamp(n,min,max) (n > max ? max : ( n < min ? min : n ))

// Macro: unsigned(i)
// Converts int i to an unsigned variant.
#define unsigned(i) i<0?0:i

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
		GetTag(o) + ",[" + \
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

#define lv_i(o,n) GetLocalInt(o,n)
#define slv_i(o,n,v) SetLocalInt(o,n,v)
#define dlv_i(o,n) DeleteLocalInt(o,n)

#endif


