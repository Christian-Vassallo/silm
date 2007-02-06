#include "_crypto"
#include "_chat"
#include "_gen"
#include "inc_cdb"
#include "inc_voice_inc"

const int
LANGUAGE_INVALID = 0,
LANGUAGE_ELF = 1,
LANGUAGE_GNOME = 2,
LANGUAGE_HALFLING = 3,
LANGUAGE_DWARF = 4,
LANGUAGE_ORC = 5,
LANGUAGE_GOBLIN = 6,
LANGUAGE_DRACONIC = 7,
LANGUAGE_SYLVAN = 8,
LANGUAGE_CANT = 9,
LANGUAGE_CELESTIAL = 10,
LANGUAGE_ABYSSAL = 11,
LANGUAGE_INFERNAL = 12,
LANGUAGE_DROW = 13,

LANGUAGE_DRUID = 14,

LANGUAGE_CHONDATHAN = 15,
LANGUAGE_ILLUSKAN = 16,


LANGUAGE_GIANT = 17,
LANGUAGE_GNOLL = 18,

// Elemental Languages
LANGUAGE_AURAN = 20,
LANGUAGE_IGNAN = 21,
LANGUAGE_TERRAN = 22,
LANGUAGE_AQUAN = 23,

// 'fun' languages, might not be implemented at all
LANGUAGE_BASE64 = 50,     // Todo

LANGUAGE_UNDERCOMMON = 90,     // Todo

LANGUAGE_UNKNOWN = 98,
LANGUAGE_COMMON = 99,
LANGUAGE_NATIVE = 100;     // Special token, do not use

const int
LANGUAGE_LORE_SKILL = 16;

const string
LANGUAGE_ITEM_TAG = "lang_";


// Translates sText into iLang
string Translate(int iLang, string sText);

// Returns the default RACIAL language of oPC
int GetDefaultRacialLanguage(object oPC);

// Returns the Language id by a given string represenation, eg 'orc'
int GetLanguageByString(string sLangStr);

string GetLanguageName(int iID);

// Makes OBJECT_SELF speak the given string fully emote- and language-parsed.
void SpeakStringLanguage(string sPhrase, int iLang = LANGUAGE_NATIVE, int nTalkVolume = TALKVOLUME_TALK);

// Makes OBJECT_SELF speak the given string fully emote- and language-parsed.
// Queues up as action.
void ActionSpeakStringLanguage(string sPhrase, int iLang = LANGUAGE_NATIVE, int nTalkVolume = TALKVOLUME_TALK);

// Returns the distance to which a mode can be heard.
float GetListeningDistance(int nTalkVolume);

// For broadcasting notifications. _No need_ to be called directly.
void SpeakLanguageToOthers(object oTalker, string sOriginal, int iLang, int nTalkVolume);

// Returns TRUE if sCharacter is alphanumeric.
int GetIsAlphanumeric(string sCharacter);

/* impl */

float GetListeningDistance(int nMode) {
	switch ( nMode ) {
		case TALKVOLUME_TALK:
			return 20.0;

		case TALKVOLUME_WHISPER:
			return 3.0;

		case TALKVOLUME_SHOUT:
			return 45.0;
	}

	return 0.0;
}

int GetLanguageByString(string sLangStr) {
	string s = GetStringLowerCase(sLangStr);

	if ( s == "lu" )
		return LANGUAGE_UNKNOWN;

	if ( s == "e" || s == "elvish" || s == "elf" || s == "elven" || s == "elfisch" )
		return LANGUAGE_ELF;

	if ( s == "gn" || s == "gnome" || s == "gn" )
		return LANGUAGE_GNOME;

	if ( s == "ha" || s == "halfling" || s == "half" || s == "halbling" )
		return LANGUAGE_HALFLING;

	if ( s == "dw" || s == "dwar" || s == "dwarf" || s == "dwarvish" || s == "zw" || s == "zwerg" )
		return LANGUAGE_DWARF;

	if ( s == "orc" || s == "ork" )
		return LANGUAGE_ORC;

	if ( s == "goblin" || s == "gob" )
		return LANGUAGE_GOBLIN;

	if ( s == "dr" || s == "dra" || s == "drac" || s == "draconic" || s == "drak" )
		return LANGUAGE_DRACONIC;

	if ( s == "syl" || s == "sylvan" )
		return LANGUAGE_SYLVAN;

	if ( s == "tc" || s == "cant" )
		return LANGUAGE_CANT;

	if ( s == "cel" || s == "celestial" )
		return LANGUAGE_CELESTIAL;

	if ( s == "ab" || s == "abyssal" )
		return LANGUAGE_ABYSSAL;

	if ( s == "if" || s == "inf" || s == "in" || s == "infernal" )
		return LANGUAGE_INFERNAL;

	if ( s == "drow" )
		return LANGUAGE_DROW;

	if ( s == "druid" || s == "dru" )
		return LANGUAGE_DRUID;

	if ( s == "gnoll" )
		return LANGUAGE_GNOLL;

	if ( s == "giant" || s == "riese" )
		return LANGUAGE_GIANT;

	if ( s == "auran" )
		return LANGUAGE_AURAN;

	if ( s == "ignan" )
		return LANGUAGE_IGNAN;

	if ( s == "terran" )
		return LANGUAGE_TERRAN;

	if ( s == "aquan" )
		return LANGUAGE_AQUAN;

	if ( s == "chondathan" || s == "chond" )
		return LANGUAGE_CHONDATHAN;

	if ( s == "illuskan" || s == "illusk" )
		return LANGUAGE_ILLUSKAN;

	if ( s == "ucommon" || s == "undercommon" )
		return LANGUAGE_UNDERCOMMON;

	if ( s == "common" || s == "handel" )
		return LANGUAGE_COMMON;

	return LANGUAGE_INVALID;
}


string GetLanguageName(int iID) {
	switch ( iID ) {
		case LANGUAGE_UNKNOWN:
			return "Unbekannte Sprache";

		case LANGUAGE_ELF:
			return "Elf";

		case LANGUAGE_GNOME:
			return "Gnomisch";

		case LANGUAGE_HALFLING:
			return "Halbling";

		case LANGUAGE_DWARF:
			return "Zwerg";

		case LANGUAGE_ORC:
			return "Ork";

		case LANGUAGE_GOBLIN:
			return "Goblinoid";

		case LANGUAGE_DRACONIC:
			return "Drakonisch";

		case LANGUAGE_SYLVAN:
			return "Sylvan";

		case LANGUAGE_CANT:
			return "Diebessprache";

		case LANGUAGE_CELESTIAL:
			return "Celestisch";

		case LANGUAGE_ABYSSAL:
			return "Abyssal";

		case LANGUAGE_INFERNAL:
			return "Infernal";

		case LANGUAGE_DROW:
			return "Drow";

		case LANGUAGE_GNOLL:
			return "Gnoll";

		case LANGUAGE_GIANT:
			return "Riese";

		case LANGUAGE_AURAN:
			return "Auran";

		case LANGUAGE_IGNAN:
			return "Ignan";

		case LANGUAGE_TERRAN:
			return "Terran";

		case LANGUAGE_AQUAN:
			return "Aquan";

		case LANGUAGE_CHONDATHAN:
			return "Chondathan";

		case LANGUAGE_ILLUSKAN:
			return "Illuskan";

		case LANGUAGE_DRUID:
			return "Druidisch";

		case LANGUAGE_UNDERCOMMON:
			return "Undercommon";

		case LANGUAGE_COMMON:
			return "Handelssprache";

	}

	return "Ungueltige Sprache (Fehler)";
}

int GetDefaultRacialLanguage(object oPC) {
	switch ( GetRacialType(oPC) ) {
		case RACIAL_TYPE_DWARF:
			return LANGUAGE_DWARF;

		case RACIAL_TYPE_ELF:
		case RACIAL_TYPE_HALFELF:
			return LANGUAGE_ELF;

		case RACIAL_TYPE_GNOME:
			return LANGUAGE_GNOME;

		case RACIAL_TYPE_HALFLING:
			return LANGUAGE_HALFLING;

		case RACIAL_TYPE_HUMANOID_ORC:
		case RACIAL_TYPE_HALFORC:
			return LANGUAGE_ORC;

		case RACIAL_TYPE_HUMANOID_GOBLINOID:
			return LANGUAGE_GOBLIN;

			//case RACIAL_TYPE_HUMANOID_REPTILIAN:
			//    return LANGUAGE_DRACONIC;
		case RACIAL_TYPE_DRAGON:
			return LANGUAGE_DRACONIC;

		case RACIAL_TYPE_GIANT:
			return LANGUAGE_GIANT;

		default:
			if ( GetLevelByClass(CLASS_TYPE_RANGER, oPC) || GetLevelByClass(CLASS_TYPE_DRUID, oPC) ) {
				return LANGUAGE_SYLVAN;
			}
			if ( GetLevelByClass(CLASS_TYPE_ROGUE, oPC) ) {
				return LANGUAGE_CANT;
			}
			break;
	}

	return LANGUAGE_INVALID;
}


int GetIsAlphanumeric(string sCharacter) {
	return -1 != FindSubString("0123456789abcdefghijklmnopqrstuvwxyzüäö", GetStringLowerCase(sCharacter));
}

string TranslateCommonToLanguage(int iLang, string sText) {
	switch ( iLang ) {
		case LANGUAGE_ELF: //Elven
			return Elven(sText);

		case LANGUAGE_GNOME: //Gnome
			return Gnome(sText);

		case LANGUAGE_HALFLING: //Halfling
			return Halfling(sText);

		case LANGUAGE_DWARF: //Dwarf
			return Dwarf(sText);

		case LANGUAGE_ORC: //Orc
			return Orc(sText);

		case LANGUAGE_GIANT:
			return Giant(sText);

		case LANGUAGE_GNOLL:
			return Gnoll(sText);

		case LANGUAGE_GOBLIN: //Goblin
			return Goblin(sText);

		case LANGUAGE_DRACONIC: //Draconic
			return Draconic(sText);

		case LANGUAGE_SYLVAN: //SYLVAN
			return Sylvan(sText);

		case LANGUAGE_CANT: //Thieves Cant
			return Cant(sText);

		case LANGUAGE_CELESTIAL: //Celestial
			return Celestial(sText);

		case LANGUAGE_ABYSSAL: //Abyssal
			return Abyssal(sText);

		case LANGUAGE_INFERNAL: //Infernal
			return Infernal(sText);

		case LANGUAGE_DROW:
			return Drow(sText);

		case LANGUAGE_DRUID:
			return Druid(sText);

		case LANGUAGE_AURAN:
			return Auran(sText);

		case LANGUAGE_IGNAN:
			return Ignan(sText);

		case LANGUAGE_AQUAN:
			return Aquan(sText);

		case LANGUAGE_TERRAN:
			return Terran(sText);

		case LANGUAGE_CHONDATHAN:
			return Chondathan(sText);

		case LANGUAGE_ILLUSKAN:
			return Illuskan(sText);

		case LANGUAGE_UNDERCOMMON:
			return Undercommon(sText);

		case LANGUAGE_UNKNOWN:
			return Unknown(sText);

		case LANGUAGE_COMMON:
			return sText;

		default:
			break;
	}

	return "";
}

string Translate(int iLang, string sPhrase) {
	string sOutput;
	int iEmote, iClear;

	if ( iLang == LANGUAGE_COMMON )
		return sPhrase;

	while ( GetStringLength(sPhrase) > 0 ) {
		if ( GetStringLeft(sPhrase, 1) == "*" )
			iEmote = abs(iEmote - 1);

		if ( GetStringLeft(sPhrase, 1) == "_" ) {
			iClear = abs(iClear - 1);

		} else {
			if ( iEmote || iClear ) {
				sOutput += GetStringLeft(sPhrase, 1);
			} else {
				sOutput += TranslateCommonToLanguage(iLang, GetStringLeft(sPhrase, 1));
			}
		}

		sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase) - 1);
	}

	return sOutput;
}



void SpeakStringLanguage(string sPhrase, int iLang = LANGUAGE_NATIVE, int nTalkVolume = TALKVOLUME_TALK) {
	if ( iLang == LANGUAGE_NATIVE )
		iLang = GetDefaultRacialLanguage(OBJECT_SELF);

	string sText = Translate(iLang, sPhrase);
	if ( sText == "" )
		return;

	SpeakString(sText, nTalkVolume);

	if ( LANGUAGE_COMMON != iLang )
		SpeakLanguageToOthers(OBJECT_SELF, sPhrase, iLang, nTalkVolume);
}



void ActionSpeakStringLanguage(string sPhrase,  int iLang = LANGUAGE_NATIVE,
							   int nTalkVolume = TALKVOLUME_TALK) {
	if ( iLang == LANGUAGE_NATIVE )
		iLang = GetDefaultRacialLanguage(OBJECT_SELF);

	string sText = Translate(iLang, sPhrase);
	if ( sText == "" )
		return;

	ActionSpeakString(sText, nTalkVolume);

	if ( LANGUAGE_COMMON != iLang ) {
		ActionDoCommand(SpeakLanguageToOthers(OBJECT_SELF, sPhrase, iLang, nTalkVolume));
	}
}



void SpeakLanguageToOthers(object oTalker, string sOriginal, int iLang, int nTalkVolume) {
	if ( LANGUAGE_COMMON == iLang )
		return;

	string sLangName = GetLanguageName(iLang);

	float fSize = GetListeningDistance(nTalkVolume);

	if ( fSize > 0.0 ) {
		object oListen = GetFirstPC();
		while ( GetIsObjectValid(oListen) ) {
			int bHeard = ( GetArea(oListen) == GetArea(oTalker) )
						 && ( CheckMask(oTalker) || CheckMask(oListen) || GetObjectHeard(oListen, oTalker) );

			float fDist = GetDistanceBetween(oTalker, oListen);
			object oLangItem = GetItemPossessedBy(oListen, LANGUAGE_ITEM_TAG + IntToString(iLang));

			if ( bHeard && fDist <= fSize ) {
				if ( CheckMask(oListen) || GetIsObjectValid(oLangItem) ) {
					SendMessageToPC(oListen, "(" + sLangName + ") " + GetName(oTalker) +
						( nTalkVolume ==
						 TALKVOLUME_SHOUT ? " RUFT" : ( nTalkVolume == TALKVOLUME_WHISPER ? " fluestert" : "" ) )
						+ ": " + sOriginal);
				}
			}

			oListen = GetNextPC();
		}
	}
}
