/*
 * Server-wide configurable parameters
 */


//How many minutes does a game hour have
const int C_MINUTES_PER_HOUR = 15;

//Time to pass between two restings
const int C_HOURS_BETWEEN_REST = 4;

//Reserved GM slots
const int C_GM_SLOTS = 2;

//Maximum number of items in storage chest
const int C_CHEST_SIZE = 60;

//Combat XP cap for players
const int C_COMBAT_XP_MAX = 50000;

//Combat XP scale slider
float C_COMBAT_XP_SCALE = 0.05;

//Combat XP cap per week real time - fixed part
const int C_COMBAT_XP_1 = 400;

// XP through auto XP (n/intvl)
const int C_TIME_XP_MONTH = 1320;
// xp per day
const int C_TIME_XP_DAY = 120;

const int
// Results in 96XP/4h
TIME_XP_AMOUNT = 3,
TIME_XP_INTERVAL = 300, // 60 * 5, 

// only give XP if player said something in the last n seconds.
TIME_XP_MAX_MESSAGE_TIME = 0,

// only if the player moved in the last n seconds
TIME_XP_MAX_MOVE_TIME = 0;



//Combat XP cap per week real time - proportionality factor to level
const int C_COMBAT_XP_2 = 0;

//Fraction of Combat XP cap for one hour real online time
const int C_COMBAT_XP_OLH_FRAC = 3;

//General XP scale slider
float C_XP_SCALE = 1.00;

//Level difference cap for weighted average calculation for group XP awards
const int C_MAX_LEVEL_DIFFERENCE = 3;



/* WARNING! Changing values below these lines may break functionality of server! */

string C_DB_PREF_PLAYER = "DB_PL_";

string C_DB_PREF_OBJECT = "DB_OB_";



// LETOSCRIPT, _letoinc, _leto
const string NWN_DIR = "/home/nwn/NWN/";
const string DB_NAME = "leto";
const string DB_EXT  = ".FPT";
const string DB_GATEWAY_VAR = "nwnxleto";
const string WP_LIMBO = "wp_limbo";
