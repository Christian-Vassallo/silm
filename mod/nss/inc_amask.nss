const int
// Normal players
AMASK_ANY = 0,

AMASK_SEE_ALL_CHARACTERS = 1,
AMASK_IS_CHARACTER_ADMIN = 2,

AMASK_CAN_USE_MACROS = 4,

// can see the mentor stats in the database
AMASK_SEE_ALL_MENTORS = 8,

// may use certain commands
// while logged in as a gm
AMASK_IS_GM = 16,
AMASK_GM = 16,

// May use IS_GM commands as
// a player too
AMASK_IS_GLOBAL_GM = 32,
AMASK_GLOBAL_GM = 32,

// May .-talk npcs as player.
AMASK_FORCETALK = 64, 

// May .-talk things as player.
AMASK_GLOBAL_FORCETALK = 128,

// Can set objects as persistent/nonpersistent
AMASK_CAN_SET_PERSISTENCY = 256,

// Can change the weather!
AMASK_CAN_CHANGE_WEATHER = 512,

// Can see the crafting database
AMASK_CAN_SEE_CRAFTING = 1024,

// Can change the crafting database
AMASK_CAN_EDIT_CRAFTING = 2048,

// Can see all merchants
AMASK_CAN_SEE_MERCHANTS = 4096,

// Can edit merchants
AMASK_CAN_EDIT_MERCHANTS = 8192,

// Can use global /lastlog
// can see the chatlogs in the cdb
AMASK_CAN_SEE_CHATLOGS = 16384,

AMASK_CAN_SEE_PRIVATE_CHATLOGS = 32768,

// can see all audit trails!
AMASK_CAN_SEE_AUDIT_TAILS = 65536,

AMASK_CAN_RESTART_SERVER = 131072,

// can see global variables
AMASK_CAN_SEE_GV = 262144,

// can edit global variables
AMASK_CAN_EDIT_GV = 524288,

AMASK_CAN_SEE_ACCOUNT_DETAILS = 1048576,

// /rmnx
// /sql
AMASK_CAN_DO_BACKEND = 8589934592; // 2<<32

// Returns > 0 if oPC has nAMask, 0 otherwise
// The special case DM/Non-DM for AMASK_GM
// is handled here for convenience.
// 
// This means that
//  * amask(oDM, AMASK_GLOBAL_GM) => 1
//   if oDM has an amask of AMASK_GM only
//
//  * amask(oPC, AMASK_GLOBAL_GM) => 0
//   if oPC has an amask of AMASK_GM only
//
//  * amask(oPC, AMASK_GLOBAL_GM) => 1
//   if oPC has an amask of AMASK_GLOBAL_GM
//
int amask(object oPC, int nAMask);

/* implementation below */

int amask(object oPC, int nAMask) {
    string sAcc = GetPCName(oPC);

	if ( "" == sAcc )
        return 0;

	if (AMASK_ANY == nAMask)
		return 1;

    int nMask = GetLocalInt(GetModule(), sAcc + "_amask");

	if (GetIsDM(oPC) && nMask & AMASK_GM && nAMask & AMASK_GLOBAL_GM)
		return 1;
	
	if (!GetIsDM(oPC) && nMask & AMASK_GLOBAL_GM && nAMask & AMASK_GM)
		return 1;

    return
           ( nMask & nAMask ) > 0;
}

