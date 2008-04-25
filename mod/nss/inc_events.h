/* Note: nwns int overflows at 1 << 31, so 1 << 30 is the highest usable bitmask */

/*
Section: Events

	Each event constant has zero or more of the following modifiers  Const: 
	- defer - Event always runs deferred (scripts registered for sync execution will *NOT RUN*), always implies *no abort*
	- sync - Event always runs synchronously (scripts registered for deferred execution will be forced to run sync)
	- abort - Event can be aborted by returning EVENT_EXECUTE_SCRIPT_ABORT if the script is running sync
	- runnable: object - what object the event will run on
	- actor: object - what object the actor will be
	- actedon: object - what object the actedon will be
	- actedat: location - what location actedat will be

	sync, abort, defer  Const: 
	- Event scripts can be run either in *sync* or in *defer* mode.
	- sync mode has the advantage of allowing event cancellation, but *will block* (and possibly run against TMI).
	- defer mode will be queued for execution after the current script, and *order of events is not guaranteed*.
	Also, event-specific native functions that return event-related data are *not guaranteed to be consistent*.
	Do NOT use them, use the provided objects (actor, actedon, actedat) by the event system instead. If you
	require any other event-related information, use sync mode.
	- If possible, choose defer mode for performance and stability.
	- Some events are forced to run in sync mode for technical reasons.
	- Some events are forced to run in defer mode (since there would be no advantage running them in sync mode, or the overhead would be too great).

Section: Script Return Codes
return codes for event scripts

	Const: EVENT_EXECUTE_SCRIPT_FAILED
		Script failed to run

	Const: EVENT_EXECUTE_SCRIPT_CONTINUE
		Script ran and execution continues

	Const: EVENT_EXECUTE_SCRIPT_END
		Script ran and execution of further events stops

	Const: EVENT_EXECUTE_SCRIPT_ABORT
		Script ran and requested termination/cancellation of the event


Section: Event Modes

	const: EVENT_MODE_ANY
		allow any mode (default)

	const: EVENT_MODE_SYNC
		sync mode

	const: EVENT_MODE_DEFER
		defer mode


Section: Event Types

	Const: EVENT_TYPE_GLOBAL
		Global and misc. events

	Const: EVENT_TYPE_PC
		Player-related events (both DMs and normal players)

	Const: EVENT_TYPE_ITEM
		Item events

	Const: EVENT_TYPE_CREATURE
		Creature events

	Const: EVENT_TYPE_PLACEABLE
		Placeable events

	Const: EVENT_TYPE_AREA
		Area events

	Const: EVENT_TYPE_DOOR
		Door events


Section: Global Events

	Const: EVENT_ANY
		match any event that appears

	Const: EVENT_GLOBAL_MODULE_LOAD
		after all module initialisation is done
		- defer

	Const: EVENT_GLOBAL_HB
		global module heartbeat
		- defer


	Const: EVENT_GLOBAL_SPELL
		a spell gets cast
		- abort (through spellhook)


	Const: EVENT_GLOBAL_OBJECT_CREATE
		Any object gets created through CreateObject
		- sync
		- abort


	const: EVENT_GLOBAL_OBJECT_DESTROY
		Any object gets destroyed through DestroyObject
		- sync
		- abort


	const: EVENT_GLOBAL_XP_SET
		A player object changes experience through SetXP
		- sync
		- abort
		- i0: nXpAmount

	const: EVENT_GLOBAL_XP_GIVE
		A player object gains experience through GiveXPToCreature
		- sync
		- abort
		- i0: nXpAmount

Section: Item Events
runnable: the item object, actor: creature involved

	Const: EVENT_ITEM_FREEACTIVATE
		Creature activates item as a free action
		- sync
		- abort
		- actedon/at: target object/location


	Const: EVENT_ITEM_ACTIVATE
		Creature activates item

	Const: EVENT_ITEM_EQUIP
		Creature equips item

	Const: EVENT_ITEM_UNEQUIP
		Creature unequips item

	Const: EVENT_ITEM_ONHITCAST
		Item gets hit physically

	Const: EVENT_ITEM_ACQUIRE
		Creature gains item

	Const: EVENT_ITEM_UNACQUIRE
		Creature loses item

	Const: EVENT_ITEM_SPELLCAST
		Item targeted by a spell
		- abort (through spellhook)


Section: Player Events
runnable: the player object

	Const: EVENT_PC_LOGIN
		Player logs in
		- defer


	Const: EVENT_PC_LOGOUT
		Player logs out
		- defer


	Const: EVENT_PC_LEVELUP
		Player gains a level
		- defer


	Const: EVENT_PC_REST
		Player rests, also fires EVENT_CREATURE_REST
		- abort


	Const: EVENT_PC_DYING
		Player is dying, also fires EVENT_CREATURE_DYING

	Const: EVENT_PC_DEATH
		Player died, also fires EVENT_CREATURE_DEATH

	Const: EVENT_PC_REPAWN
		Player respawns

	Const: EVENT_PC_CUTSCENEABRT
		Cutscene got aborted
		- defer


	Const: EVENT_PC_USEFEAT
		Player uses a feat
		- sync
		- abort


	Const: EVENT_PC_USESKILL
		Player uses a feat
		- sync
		- abort


	Const: EVENT_PC_TOGGLEMODE
		Player toggles one of ACTION_MODE_*
		- sync
		- abort


	Const: EVENT_PC_EXAMINE
		Player uses Examine
		- sync
		- abort


	Const: EVENT_PC_ATTACK
		Player attacks something
		- sync
		- abort
		- actor: attacker
		- actedon: attackee


	Const: EVENT_PC_PICKPOCKET
		Player pickpockets someone
		- sync
		- abort
		- actor: pickpocket
		- actedon: pickpocket target


	Const: EVENT_PC_SAVE
		Player character gets saved

	Const: EVENT_PC_QUICKCHAT
		Player uses quickchat


Section: Creature Events
runnable: the creature object

	Const: EVENT_CREATURE_ATTACK
		A creature gets attacked

	Const: EVENT_CREATURE_DAMAGE
		A creature gets damaged

	Const: EVENT_CREATURE_DYING
		A creature is about to die

	Const: EVENT_CREATURE_DEATH
		A creature dies
		- actor: killer

	Const: EVENT_CREATURE_DIALOGUE
		A creature wants to talk

	Const: EVENT_CREATURE_DISTURB
		A creature gets disturbed

	Const: EVENT_CREATURE_ENDROUND
		A creature ends it round

	Const: EVENT_CREATURE_HB
		Creature heartbeat

	Const: EVENT_CREATURE_BLOCK
		A creature is blocked and cannot pathfind

	Const: EVENT_CREATURE_NOTICE
		? wot does dis doo.

	Const: EVENT_CREATURE_REST
		A creature rests

	Const: EVENT_CREATURE_SPAWN
		A creature spawns

	Const: EVENT_CREATURE_SPELLCAST
		A creature gets a spell cast at


Section: Placeable Events
runnable: the placeable, actor: creature

	Const: EVENT_PLACEABLE_CLICK
		When a creature clicks on a placeable

	Const: EVENT_PLACEABLE_CLOSE
		Container gets closed

	Const: EVENT_PLACEABLE_DAMAGE
		Placeable gets damaged

	Const: EVENT_PLACEABLE_DEATH
		Placeable gets destroyed

	Const: EVENT_PLACEABLE_DISARM
		Placeable gets disarmed

	Const: EVENT_PLACEABLE_HB
		Heartbeat (actor: n/a)

	Const: EVENT_PLACEABLE_INVDIST
		Container gains item/loses item/item gets stolen out of
		- actedon: item

	Const: EVENT_PLACEABLE_LOCK
		Placeable gets locked

	Const: EVENT_PLACEABLE_MELEEATTACK
		Placeable gets bashed

	Const: EVENT_PLACEABLE_OPEN
		Container gets opened

	Const: EVENT_PLACEABLE_SPELLCAST
		Placeable gets spell cast at

	Const: EVENT_PLACEABLE_TRAPTRIG
		Placeable trap gets triggered

	Const: EVENT_PLACEABLE_UNLOCK
		Placeable gets unlocked

	Const: EVENT_PLACEABLE_USE
		Placeable gets used


Section: Area Events
runnable: the area

	Const: EVENT_AREA_ENTER
		Creature enters an area
		- actedon: creature

	Const: EVENT_AREA_EXIT
		Creature leaves an area
		- actedon: creature

	Const: EVENT_AREA_HB
		Heartbeat for area (actor: n/a)


Section: Door Events
runnable: the door, actor: creature

	Const: EVENT_DOOR_CLICK
		Door gets glicked

	Const: EVENT_DOOR_DAMAGE
		Door gets damaged

	Const: EVENT_DOOR_DEATH
		Door gets destroyed

	Const: EVENT_DOOR_DISARM
		Door (trap) gets disarmed

	Const: EVENT_DOOR_HB
		Door heartbeat

	Const: EVENT_DOOR_LOCK
		Door gets locked

	Const: EVENT_DOOR_UNLOCK
		Door gets unlocked

	Const: EVENT_DOOR_MELEEATTACK
		Door gets physically attacked

	Const: EVENT_DOOR_SPELLCAST
		Door gets spell cast at

	Const: EVENT_DOOR_TRAPTRIG
		Door trap gets triggered

	Const: EVENT_DOOR_OPEN
		Creature opens a door

	Const: EVENT_DOOR_FAILTOOPEN
		Door fails to open

	Const: EVENT_DOOR_CLOSE
		Creature closes a door


*/
// Struct: EventInfo
// A struct containing various information
// relating the event.
struct EventInfo {

	// Var: mode
	// The EVENT_MODE_*
	int mode;

	// Var: type
	// The EVENT_TYPE_*
	int type;

	// Var: ev
	// The EVENT_*_*
	int ev;

	// Var: defer_time
	// How many seconds this event is late
	float defer_time;

	// Var: event_mask
	int event_mask;

	// Var: runnable
	// The object this event runs on, usually OBJECT_SELF
	object runnable;

	// Var: actor
	// The actor of the event
	object actor;

	// Var: actedon
	// the object the event acted on
	object actedon;

	// Var: actedat
	// The location where the event took place
	location actedat;
};

// Struct: EventArguments
// A struct containing arguments passed by the
// event source. Refer to the individual event
// documentation to find out the meaning and
// contents of each argument.
// Yes, this is ugly.
// Improvements welcome.
struct EventArguments {
	// Vars: a0, a1, a2
	string a0, a1, a2;
	// Vars: i0, i1, i2
	int i0, i1, i2;
	// Vars: f0, f1, f2
	float f0, f1, f2;
	// Vars: o0, o1, o2
	object o0, o1, o2;
	// Vars: l0, l1, l2
	location l0, l1, l2;
};


const int EVENT_SCRIPT_LENGTH = 16;

const int EVENT_EXECUTE_SCRIPT_CONTINUE = 1 << 0;
const int EVENT_EXECUTE_SCRIPT_FAILED = 1 << 1;
const int EVENT_EXECUTE_SCRIPT_ABORT = 1 << 2;
const int EVENT_EXECUTE_SCRIPT_END = 1 << 3;

const int EVENT_MODE_ANY = 1 << 0;
const int EVENT_MODE_SYNC = 1 << 1;
const int EVENT_MODE_DEFER = 1 << 2;

const int EVENT_TYPE_GLOBAL = 0;
const int EVENT_TYPE_PC = 1;
const int EVENT_TYPE_ITEM = 2;
const int EVENT_TYPE_CREATURE = 3;
const int EVENT_TYPE_PLACEABLE = 4;
const int EVENT_TYPE_AREA = 5;
const int EVENT_TYPE_DOOR = 6;


const int EVENT_ANY = 0;

/* This was autogenerated with rebuild_events.rb */
const int EVENT_GLOBAL_MODULE_LOAD = 1 << 0;
const int EVENT_GLOBAL_HB = 1 << 1;
const int EVENT_GLOBAL_SPELL = 1 << 2;
const int EVENT_GLOBAL_OBJECT_CREATE = 1 << 3;
const int EVENT_GLOBAL_OBJECT_DESTROY = 1 << 4;
const int EVENT_GLOBAL_XP_SET = 1 << 5;
const int EVENT_GLOBAL_XP_GIVE = 1 << 6;
const int EVENT_ITEM_FREEACTIVATE = 1 << 0;
const int EVENT_ITEM_ACTIVATE = 1 << 1;
const int EVENT_ITEM_EQUIP = 1 << 2;
const int EVENT_ITEM_UNEQUIP = 1 << 3;
const int EVENT_ITEM_ONHITCAST = 1 << 4;
const int EVENT_ITEM_ACQUIRE = 1 << 5;
const int EVENT_ITEM_UNACQUIRE = 1 << 6;
const int EVENT_ITEM_SPELLCAST = 1 << 7;
const int EVENT_PC_LOGIN = 1 << 0;
const int EVENT_PC_LOGOUT = 1 << 1;
const int EVENT_PC_LEVELUP = 1 << 2;
const int EVENT_PC_REST = 1 << 3;
const int EVENT_PC_DYING = 1 << 4;
const int EVENT_PC_DEATH = 1 << 5;
const int EVENT_PC_REPAWN = 1 << 6;
const int EVENT_PC_CUTSCENEABRT = 1 << 7;
const int EVENT_PC_USEFEAT = 1 << 8;
const int EVENT_PC_USESKILL = 1 << 9;
const int EVENT_PC_TOGGLEMODE = 1 << 10;
const int EVENT_PC_EXAMINE = 1 << 11;
const int EVENT_PC_ATTACK = 1 << 12;
const int EVENT_PC_PICKPOCKET = 1 << 13;
const int EVENT_PC_SAVE = 1 << 14;
const int EVENT_PC_QUICKCHAT = 1 << 15;
const int EVENT_CREATURE_ATTACK = 1 << 0;
const int EVENT_CREATURE_DAMAGE = 1 << 1;
const int EVENT_CREATURE_DYING = 1 << 2;
const int EVENT_CREATURE_DEATH = 1 << 3;
const int EVENT_CREATURE_DIALOGUE = 1 << 4;
const int EVENT_CREATURE_DISTURB = 1 << 5;
const int EVENT_CREATURE_ENDROUND = 1 << 6;
const int EVENT_CREATURE_HB = 1 << 7;
const int EVENT_CREATURE_BLOCK = 1 << 8;
const int EVENT_CREATURE_NOTICE = 1 << 9;
const int EVENT_CREATURE_REST = 1 << 10;
const int EVENT_CREATURE_SPAWN = 1 << 11;
const int EVENT_CREATURE_SPELLCAST = 1 << 12;
const int EVENT_PLACEABLE_CLICK = 1 << 0;
const int EVENT_PLACEABLE_CLOSE = 1 << 1;
const int EVENT_PLACEABLE_DAMAGE = 1 << 2;
const int EVENT_PLACEABLE_DEATH = 1 << 3;
const int EVENT_PLACEABLE_DISARM = 1 << 4;
const int EVENT_PLACEABLE_HB = 1 << 5;
const int EVENT_PLACEABLE_INVDIST = 1 << 6;
const int EVENT_PLACEABLE_LOCK = 1 << 7;
const int EVENT_PLACEABLE_MELEEATTACK = 1 << 8;
const int EVENT_PLACEABLE_OPEN = 1 << 9;
const int EVENT_PLACEABLE_SPELLCAST = 1 << 10;
const int EVENT_PLACEABLE_TRAPTRIG = 1 << 11;
const int EVENT_PLACEABLE_UNLOCK = 1 << 12;
const int EVENT_PLACEABLE_USE = 1 << 13;
const int EVENT_AREA_ENTER = 1 << 0;
const int EVENT_AREA_EXIT = 1 << 1;
const int EVENT_AREA_HB = 1 << 2;
const int EVENT_DOOR_CLICK = 1 << 0;
const int EVENT_DOOR_DAMAGE = 1 << 1;
const int EVENT_DOOR_DEATH = 1 << 2;
const int EVENT_DOOR_DISARM = 1 << 3;
const int EVENT_DOOR_HB = 1 << 4;
const int EVENT_DOOR_LOCK = 1 << 5;
const int EVENT_DOOR_UNLOCK = 1 << 6;
const int EVENT_DOOR_MELEEATTACK = 1 << 7;
const int EVENT_DOOR_SPELLCAST = 1 << 8;
const int EVENT_DOOR_TRAPTRIG = 1 << 9;
const int EVENT_DOOR_OPEN = 1 << 10;
const int EVENT_DOOR_FAILTOOPEN = 1 << 11;
const int EVENT_DOOR_CLOSE = 1 << 12;

