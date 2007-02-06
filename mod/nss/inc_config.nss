/*
 * Server-wide configurable parameters
 */


//How many minutes does a game hour have
int C_MINUTES_PER_HOUR = 15;

//Time to pass between two restings
int C_HOURS_BETWEEN_REST = 4;

//Reserved GM slots
int C_GM_SLOTS = 2;

//Maximum number of items in storage chest
int C_CHEST_SIZE = 60;

//Combat XP cap for players
int C_COMBAT_XP_MAX = 50000;

//Combat XP scale slider
float C_COMBAT_XP_SCALE = 0.05;

//Combat XP cap per week real time - fixed part
int C_COMBAT_XP_1 = 800;

//Combat XP cap per week real time - proportionality factor to level
int C_COMBAT_XP_2 = 0;

//Fraction of Combat XP cap for one hour real online time
int C_COMBAT_XP_OLH_FRAC = 3;

//General XP scale slider
float C_XP_SCALE = 1.00;

//Level difference cap for weighted average calculation for group XP awards
int C_MAX_LEVEL_DIFFERENCE = 3;


/* WARNING! Changing values below these lines may break functionality of server! */

string C_DB_PREF_PLAYER = "DB_PL_";

string C_DB_PREF_OBJECT = "DB_OB_";



// LETOSCRIPT, _letoinc, _leto
const string NWN_DIR = "/home/nwn/NWN/";
const string DB_NAME = "leto";
const string DB_EXT  = ".FPT";
const string DB_GATEWAY_VAR = "nwnxleto";
const string WP_LIMBO = "wp_limbo";
