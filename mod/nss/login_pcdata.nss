#include "inc_pc_data"
#include "inc_pc_mnxnotify"
#include "inc_mysql"
#include "inc_currency"
#include "inc_xp_handling"
#include "inc_persist"
#include "inc_horse"

// Return german Alignments as String
string GetAlignment(object oPC);

// Converts Class Constante in german real Classname as String
string GetClassName(int nClass);

// Converts RacialType Constante in german real Name as String
string GetRaceName(int nRace);

void main() {

	if ( !GetIsPC(OBJECT_SELF) )
		return;

	load_player(OBJECT_SELF);

	notify_pc_login(OBJECT_SELF);

	DelayCommand(300.0, save_player(OBJECT_SELF, TRUE));

	string sCharName = SQLEncodeSpecialChars(GetName(OBJECT_SELF));
	string sKey = GetPCPublicCDKey(OBJECT_SELF);
	string sPlayerName = SQLEncodeSpecialChars(GetPCPlayerName(OBJECT_SELF));
	string sXP = IntToString(GetXP(OBJECT_SELF));
	string sGold = IntToString(GetValue(OBJECT_SELF));
	string sCombatXP = IntToString(GetCombatXP(OBJECT_SELF));
	//string sCAP = IntToString(GetPersistentInt(OBJECT_SELF,"XP_Combat_cap_num"));

	string sKlasse1 = GetClassName(GetClassByPosition(1));
	string sKlasse2 = GetClassName(GetClassByPosition(2));
	string sKlasse3 = GetClassName(GetClassByPosition(3));
	int nStufe1 = GetLevelByClass(GetClassByPosition(1));
	int nStufe2 = GetLevelByClass(GetClassByPosition(2));
	int nStufe3 = GetLevelByClass(GetClassByPosition(3));
	string sGesinnung = GetAlignment(OBJECT_SELF);
	string sRace = SQLEncodeSpecialChars(GetRaceName(GetRacialType(OBJECT_SELF)));
	string sSubRace = SQLEncodeSpecialChars(GetSubRace(OBJECT_SELF));
	string sDeity = SQLEncodeSpecialChars(GetDeity(OBJECT_SELF));

	string sSQL = "SELECT Char_Name FROM tab_chars WHERE Char_Name='" +
				  sCharName + "' AND GSA_Account='" + sPlayerName + "';";

	SQLExecDirect(sSQL);
	if ( SQLFetch() == SQL_SUCCESS ) {
		sSQL = "UPDATE tab_chars SET XP ='" +
			   sXP +
			   "', Gold ='" +
			   sGold +
			   "',LastLogin= NOW(), CombatXP ='" +
			   sCombatXP +
			   "', Gesinnung ='" +
			   sGesinnung +
			   "', Klasse1 ='" +
			   sKlasse1 +
			   "', Klasse2 ='" +
			   sKlasse2 +
			   "', Klasse3 ='" +
			   sKlasse3 +
			   "', Stufe1 =" +
			   IntToString(nStufe1) +
			   ", Stufe2 =" +
			   IntToString(nStufe2) +
			   ", Stufe3 =" +
			   IntToString(nStufe3) +
			   ", Rasse ='" +
			   sRace +
			   "', SubRasse ='" +
			   sSubRace +
			   "', Gottheit ='" +
			   sDeity + "' WHERE Char_Name='" + sCharName + "' AND GSA_Account='" + sPlayerName + "';";
		SQLExecDirect(sSQL);
	} else {

		sSQL =
			"INSERT INTO tab_chars (Char_Name, GSA_Account, XP, Gold, LastLogin, CombatXP, Gesinnung, Klasse1, Klasse2, Klasse3, Stufe1, Stufe2, Stufe3, Rasse, SubRasse, Gottheit) VALUES ('"
			+ sCharName +
			"', '" +
			sPlayerName +
			"', '" +
			sXP +
			"', '" +
			sGold +
			"', NOW(), '" +
			sCombatXP +
			"', '" +
			sGesinnung +
			"', '" +
			sKlasse1 +
			"', '" +
			sKlasse2 +
			"', '" +
			sKlasse3 +
			"', " +
			IntToString(nStufe1) +
			", " +
			IntToString(nStufe2) +
			", " + IntToString(nStufe3) + ", '" + sRace + "', '" + sSubRace + "', '" + sDeity + "');";
		SQLExecDirect(sSQL);
	}

	// Checks if CD_Key is Known for this User and Char, if not it register the used CD_Key for User and Char
	sSQL = "SELECT CD_Key FROM tab_cdkey WHERE Char_Name='" +
		   sCharName + "' AND GSA_Account='" + sPlayerName + "';";

	SQLExecDirect(sSQL);
	if ( SQLFetch() == SQL_SUCCESS ) {
		string sCD_Key = SQLGetData(1);
		int nDone = FALSE;
		while ( nDone == TRUE ) {
			if ( sCD_Key == sKey ) {
				nDone == TRUE;
			} else {
				if ( SQLFetch() == SQL_ERROR ) {
					sSQL = "INSERT INTO tab_cdkey (CD_Key, Char_Name, GSA_Account) VALUES ('" +
						   sKey + "','" + sCharName + "', '" + sPlayerName + "');";
					SQLExecDirect(sSQL);
					nDone == TRUE;
				}
			}
		}
	} else {
		sSQL = "INSERT INTO tab_cdkey (CD_Key, Char_Name, GSA_Account) VALUES ('" +
			   sKey + "','" + sCharName + "', '" + sPlayerName + "');";
		SQLExecDirect(sSQL);
	}

	int nCID = GetCharacterID(OBJECT_SELF);

	if ( GetIsRidingHorse(OBJECT_SELF) ) {
		sSQL = "SELECT name FROM tab_pferde WHERE `character` = '" + IntToString(nCID) + "' limit 1;";
		SQLExecDirect(sSQL);
		if ( SQLFetch() == SQL_SUCCESS ) {
			SetLocalString(OBJECT_SELF, "horse_name", SQLGetData(1));
		}
	}


	if ( !GetLocalInt(OBJECT_SELF, "first_login") && !GetIsDM(OBJECT_SELF) ) {
		SQLQuery("select `AreaTag`,X,Y,Z from tab_chars where Char_Name = '" +
			sCharName + "' and GSA_Account = '" + sPlayerName + "' limit 1;");
		if ( SQLFetch() ) {
			string sArea = SQLGetData(1);
			vector v;
			v.x = StringToFloat(SQLGetData(2));
			v.y = StringToFloat(SQLGetData(3));
			v.z = StringToFloat(SQLGetData(4));

			object oA = GetObjectByTag(sArea);
			if ( GetIsObjectValid(oA) ) {
				location ll = Location(oA, v, 0.0);
				object ot = OBJECT_SELF;
				AssignCommand(ot, DelayCommand(4.0, JumpToLocation(ll)));
			}
		}
		SetLocalInt(OBJECT_SELF, "first_login", 1);
	}
}

// Return Alignmentstring
string GetAlignment(object oPC) {
	string sGesinnung;
	if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ) {
		sGesinnung = "Rechtschaffen Gut";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ) {
		sGesinnung = "Neutral Gut";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ) {
		sGesinnung = "Chaotisch Gut";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL ) {
		sGesinnung = "Rechtschaffen Neutral";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL ) {
		sGesinnung = "Neutral";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL ) {
		sGesinnung = "Chaotisch Neutral";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ) {
		sGesinnung = "Rechtschaffen Boese";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ) {
		sGesinnung = "Neutral Boese";
	} else if ( GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC
			   && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL ) {
		sGesinnung = "Chaotisch Boese";
	}
	return sGesinnung;
}

string GetClassName(int nClass) {
	string sClassName;
	if ( nClass == CLASS_TYPE_ARCANE_ARCHER ) {
		sClassName = "Archaner Bogenschuetze";
	} else if ( nClass == CLASS_TYPE_ASSASSIN ) {
		sClassName = "Assassine";
	} else if ( nClass == CLASS_TYPE_BARBARIAN ) {
		sClassName = "Barbar";
	} else if ( nClass == CLASS_TYPE_BARD ) {
		sClassName = "Barde";
	} else if ( nClass == CLASS_TYPE_BLACKGUARD ) {
		sClassName = "Finsterer Streiter";
	} else if ( nClass == CLASS_TYPE_CLERIC ) {
		sClassName = "Kleriker";
	} else if ( nClass == CLASS_TYPE_DIVINE_CHAMPION || nClass == CLASS_TYPE_DIVINECHAMPION ) {
		sClassName = "Vorkaempfer Torms";
	} else if ( nClass == CLASS_TYPE_DRAGON_DISCIPLE || nClass == CLASS_TYPE_DRAGONDISCIPLE ) {
		sClassName = "Roter Drachenjuenger";
	} else if ( nClass == CLASS_TYPE_DWARVEN_DEFENDER || nClass == CLASS_TYPE_DWARVENDEFENDER ) {
		sClassName = "Zwergischer Verteidiger";
	} else if ( nClass == CLASS_TYPE_PALE_MASTER || nClass == CLASS_TYPE_PALEMASTER ) {
		sClassName = "Bleicher Meister";
	} else if ( nClass == CLASS_TYPE_DRUID ) {
		sClassName = "Druide";
	} else if ( nClass == CLASS_TYPE_FIGHTER ) {
		sClassName = "Kaempfer";
	} else if ( nClass == CLASS_TYPE_HARPER ) {
		sClassName = "Hafner Kundschafter";
	} else if ( nClass == CLASS_TYPE_MONK ) {
		sClassName = "Moench";
	} else if ( nClass == CLASS_TYPE_PALADIN ) {
		sClassName = "Paladin";
	} else if ( nClass == CLASS_TYPE_RANGER ) {
		sClassName = "Waldlaeufer";
	} else if ( nClass == CLASS_TYPE_ROGUE ) {
		sClassName = "Schurke";
	} else if ( nClass == CLASS_TYPE_SHADOWDANCER ) {
		sClassName = "Schattentaenzer";
	} else if ( nClass == CLASS_TYPE_SHAPECHANGER ) {
		sClassName = "Wahrer Wandler";
	} else if ( nClass == CLASS_TYPE_SORCERER ) {
		sClassName = "Hexenmeister";
	} else if ( nClass == CLASS_TYPE_WEAPON_MASTER ) {
		sClassName = "Waffenmeister";
	} else if ( nClass == CLASS_TYPE_WIZARD ) {
		sClassName = "Magier";
	}
	return sClassName;
}

string GetRaceName(int nRace) {
	string sRaceName;
	if ( nRace == RACIAL_TYPE_DWARF ) {
		sRaceName = "Zwerg";
	} else if ( nRace == RACIAL_TYPE_ELF ) {
		sRaceName = "Elf";
	} else if ( nRace == RACIAL_TYPE_GNOME ) {
		sRaceName = "Gnome";
	} else if ( nRace == RACIAL_TYPE_HALFELF ) {
		sRaceName = "Halbelf";
	} else if ( nRace == RACIAL_TYPE_HALFLING ) {
		sRaceName = "Halbling";
	} else if ( nRace == RACIAL_TYPE_HALFORC ) {
		sRaceName = "Halbork";
	} else if ( nRace == RACIAL_TYPE_HUMAN ) {
		sRaceName = "Mensch";
	}
	return sRaceName;
}
