#include "_gen"
#include "inc_chat"
#include "inc_target"
#include "inc_colours"
#include "inc_limbo"



const int
MAX_VFX_EFFECT_ID = 2048;     //XXX: would be better to read it over 2da?

const int
OK = 0,
NOTFOUND = 1,
SYNTAX = 2,
FAIL = 3,
ACCESS = 4;



struct Colour
cEmote = cOrange,
cNPCEmote = cDarkMagenta,
cHighLight = cYellow,
cOOC = cLightGrey,
cLanguage = cLightBlue;




void setsleep(float fWait);

float getsleep();


void setsleep(float fWait) {
	SetLocalFloat(GetModule(), "cmd_sleep", fWait);
}

float getsleep() {
	return GetLocalFloat(GetModule(), "cmd_sleep");
}


void SpeakToMode(object oPC, string sText, int iMode);

void FixFactionsForObject(object oO, object oPC = OBJECT_SELF);


void ChatHookAudit(object oPC = OBJECT_SELF, int bSuppress = TRUE, string sData = "");





// Applies emote colours to the given text.
// Parses:
//    *..* - cOrange
//    _.._ - cLightBlue
string ColourisePlayerText(object oPC, int nMode, string sText, struct Colour cTextColour);


/* implementation! */

string ColourisePlayerText(object oPC, int nMode, string sText, struct Colour cTextColour) {
	int i = 0;
	string r = "", c = "";

	int bInEmote = 0;
	int bInLB = 0;
	int bInLang = 0;
	int bInOOC = 0;

	if ( nMode & MODE_WHISPER )
		cTextColour = cDarkGrey;

	if ( GetSubString(sText, 0, 1) == "(" ) {
		return ColourTag(cOOC) + /*GetStringTrim(sText, "(", ")")*/ sText + ColourTagClose();
	}

	struct Colour cPEmote = cEmote;

	//if (!GetIsPC(oPC))
	//    cPEmote = cNPCEmote;

	if ( nMode & MODE_WHISPER ) {
		cPEmote = Darken(cPEmote, 50);
		// darken the other colours, too?
	}

	r += ColourTagClose() + ColourTag(cTextColour);

	for ( i = 0; i < GetStringLength(sText); i++ ) {
		c = GetSubString(sText, i, 1);

		if ( "*" == c ) {
			if ( bInEmote == 0 ) {
				r += ColourTag(cPEmote) + c;
				bInEmote = 1;
				continue;
			} else {
				bInEmote = 0;
				if ( bInLB )
					r += ColourTag(cHighLight);
				else
					r += "*" + ColourTag(cTextColour);
				continue;
			}
		}

		if ( "_" == c ) {
			if ( bInLB == 0 ) {
				r += ColourTag(cHighLight);
				bInLB = 1;
				continue;
			} else {
				if ( bInEmote )
					r += ColourTag(cPEmote);
				else
					r += ColourTag(cTextColour);
				bInLB = 0;
				continue;
			}
		}

		if ( "#" == c ) {
			if ( bInLang == 0 ) {
				r += ColourTag(cLanguage);
				bInLang = 1;
				continue;
			} else {
				if ( bInLB )
					r += ColourTag(cHighLight);
				else
					r += ColourTag(cTextColour);
				bInLang = 0;
				continue;
			}
		}

		/*if ("(" == c && !bInOOC) {
		 * 	r += ColourTag(cOOC);
		 * 	bInOOC = 1;
		 * 	continue;
		 * }
		 *
		 * if (")" == c && bInOOC) {
		 * 	r += ColourTagClose();
		 * 	bInOOC = 0;
		 * 	if (bInLB)
		 * 		r += ColourTag(cHighLight);
		 * 	else if (bInEmote)
		 * 			r += ColourTag(cPEmote);
		 * 	continue;
		 * } */

		r += c;
	}
	r += ColourTagClose();

	return r;
}



void SpeakToMode(object oPC, string sText, int iMode) {
	if ( "" == sText )
		return; // SIGSEGV :D

	switch ( iMode ) {
		case MODE_TALK:
			//ChatLock(oPC);
			AssignCommand(oPC, SpeakString(sText, TALKVOLUME_TALK));
			break;
		case MODE_WHISPER:
			//ChatLock(oPC);
			AssignCommand(oPC, SpeakString(sText, TALKVOLUME_WHISPER));
			break;
		case MODE_SHOUT:
			//ChatLock(oPC);
			AssignCommand(oPC, SpeakString(sText, TALKVOLUME_SHOUT));
			break;
		case MODE_DM:
			SendMessageToAllDMs(GetName(oPC) + ": " + sText);
			break;
		default:
			SendMessageToPC(oPC, "Invalid channel: " + IntToString(iMode));
			break;
	}
}



void ChatHookAudit(object oPC = OBJECT_SELF, int bSuppress = TRUE, string sData = "") {
	SetLocalInt(oPC, "chat_suppress_audit", bSuppress == TRUE);
	SetLocalString(oPC, "chat_data_audit", sData);
}



void FixFactionsForObject(object oO, object oPC = OBJECT_SELF) {
	/*
	 * legion 50   sl_bogenschuetze
	 * gabelb 50
	 * schach 50   c_gamemaster
	 * liebe 100
	 * zhent 50
	 * gnolle 0
	 * grottenschrate 0
	 * morueme 0
	 * tausend f 0
	 * rote kl 100 rk_gustav
	 * shadovar 50
	 * feuerkralle 0 fk_elitekrieger
	 * tiere 50
	 * orks 0
	 */

	SendMessageToPC(oPC, "Vorher");
	SendMessageToPC(oPC, " Buergerlich: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oO)));
	SendMessageToPC(oPC, " Verteidiger: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oO)));
	SendMessageToPC(oPC, " Haendler: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oO)));
	SendMessageToPC(oPC, " Feindlich: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_HOSTILE, oO)));

	/* First, the standard factions */
	SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 0, oO);
	SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 100, oO);
	SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 100, oO);
	SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 100, oO);

	SendMessageToPC(oPC, "Nachher");
	SendMessageToPC(oPC, " Buergerlich: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oO)));
	SendMessageToPC(oPC, " Verteidiger: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oO)));
	SendMessageToPC(oPC, " Haendler: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oO)));
	SendMessageToPC(oPC, " Feindlich: " +
		IntToString(GetStandardFactionReputation(STANDARD_FACTION_HOSTILE, oO)));


	object wLimbo = GetObjectByTag(LIMBO_WAYPOINT);
	location lLimbo = GetLocation(wLimbo);
	object oA;

	if ( !GetIsObjectValid(wLimbo) ) {
		SendMessageToAllDMs(
			"Warning, Limbo waypoint is broken. /fixfactions will not work properly for custom factions.");
		return;
	}

	/* now our own factions as listed above */

	// Legion
	oA = CreateObject(OBJECT_TYPE_CREATURE, "sl_bogenschuetze", lLimbo);
	SendMessageToPC(oPC, "V: Legion: " + IntToString(GetReputation(oA, oO)));
	AdjustReputation(oO, oA, 50 - GetReputation(oA, oO));
	SendMessageToPC(oPC, "N: Legion: " + IntToString(GetReputation(oA, oO)));
	DelayCommand(1.0, DestroyObject(oA));

	// Schach
	oA = CreateObject(OBJECT_TYPE_CREATURE, "c_gamemaster", lLimbo);
	SendMessageToPC(oPC, "V: Schach: " + IntToString(GetReputation(oA, oO)));
	AdjustReputation(oO, oA, 50 - GetReputation(oA, oO));
	SendMessageToPC(oPC, "N: Schach: " + IntToString(GetReputation(oA, oO)));
	DelayCommand(1.1, DestroyObject(oA));

	// rotekl
	oA = CreateObject(OBJECT_TYPE_CREATURE, "rk_gustav", lLimbo);
	SendMessageToPC(oPC, "V: Rote Klinge: " + IntToString(GetReputation(oA, oO)));
	AdjustReputation(oO, oA, 100 - GetReputation(oA, oO));
	SendMessageToPC(oPC, "N: Rote Klinge: " + IntToString(GetReputation(oA, oO)));
	DelayCommand(1.2, DestroyObject(oA));

	// feuerk
	oA = CreateObject(OBJECT_TYPE_CREATURE, "fk_elitekrieger", lLimbo);
	SendMessageToPC(oPC, "V: Feuerkrallen: " + IntToString(GetReputation(oA, oO)));
	AdjustReputation(oO, oA, 0 - GetReputation(oA, oO));
	SendMessageToPC(oPC, "N: Feuerkrallen: " + IntToString(GetReputation(oA, oO)));
	DelayCommand(1.3, DestroyObject(oA));

	// animals
	oA = CreateObject(OBJECT_TYPE_CREATURE, "reh", lLimbo);
	SendMessageToPC(oPC, "V: Tiere: " + IntToString(GetReputation(oA, oO)));
	AdjustReputation(oO, oA, 50 - GetReputation(oA, oO));
	SendMessageToPC(oPC, "N: Tiere: " + IntToString(GetReputation(oA, oO)));
	DelayCommand(1.4, DestroyObject(oA));

	SendMessageToPC(oPC, "Fertig.");
}
