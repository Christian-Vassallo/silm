const int
CSKILL_ALCHEMY = 1,
CSKILL_TAILOR = 31,
CSKILL_SMITH_WEAPON = 21,
CSKILL_SMITH_ARMOR = 22,
CSKILL_FLETCHER = 41;

const int
//    CSKILL_INVALID = 0,

CRAFT_LEARN_ACTIVE = 1,
CRAFT_LEARN_PASSIVE = 2,


// every time XP reaches this,
// skill is increased by one.
CRAFT_LEARN_BORDER = 200,
CRAFT_BORDER_MULTIPLICATOR = 6,
CRAFT_LEARN_BASICS = 10,

COMPONENTS_ORDER_FIXED = 0,
COMPONENTS_ORDER_ANY = 1;


const int
CRAFT_EVENT_INVALID = 0,

CRAFT_EVENT_OPEN = 1,
CRAFT_EVENT_SPELL = 2,
CRAFT_EVENT_DISTURB = 3,
CRAFT_EVENT_CLOSE = 4,
CRAFT_EVENT_FINISH = 5,

CRAFT_SCRIPT_RESULT_OK = 1,
CRAFT_SCRIPT_RESULT_FAIL = 0;

struct Recipe {
	int id;

	string resref;
	// string resref_fail;
	string workplace;
	string components;
	string name;
	string desc;

	// 0 - needs to be in the specified order.
	// 1 - can be in any random order.
	int components_order;

	// What DC to roll against to save components.
	// Rolls for each save independently.
	int components_save_dc;

	// The SPELL_* required for this or 0 for none.
	int spell0;
	int spell1;
	int spell2;
	int spell3;
	int spell4;

	// What SPELL_* to cast on the workplace on failure.
	int spell_fail;

	// The crafting skill id. See CSKILL_*
	int cskill;

	// Cannot craft this item if not meeting this
	// minimum skill level.
	int cskill_min;

	// The crafting skill at which a character may yet learn
	// new skill points.  Do not learn above this skill to
	// prevent powercrafting.
	int cskill_max;

	// What skill do we need?  The SKILL_* from the character.
	int skill;

	// What difficulty check do we need to pass?
	int skill_dc;

	// ABILITY_* to throw against
	int ability;

	// ..
	int ability_dc;

	// The FEAT_* required for this.
	int feat;

	// Create at least this many items when crafting succeeded.
	int count_min;

	// Create at most this many items when crafting succeeded.
	int count_max;

	// How many character experience points does this recipe
	// per stackitem cost?
	float xp_cost;

	// Multiply each crafting result with this.
	float practical_xp_factor;

	// How many items of this recipe can a player craft in one day?
	// 0 for unlimited.
	float max_per_day;

	// Minimum of seconds to pass between successful craftings.
	int min_timespan;

	// How long to lock the workplace after intial craft finishes
	// (eg brewing/destilling time)
	int lock_duration;

	string s_craft;
};

struct PlayerSkill {
	int id;
	int cid;

	int cskill;
	int practical;
	int epractical;
	int theory;
	int etheory;
	int practical_xp;
	int theory_xp;
	int practical_highest_learn_border;
};

struct PlayerRecipeStat {
	int id;
	int cid;

	int recipe;

	// Unix timestamp with the last update
	int last;

	// How many times did this player create that recipe successfully?
	int count;

	// reverse of above
	int fail;
};
