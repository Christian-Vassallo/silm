#include "inc_pgsql"
#include "_gen"
#include "inc_currency"
#include "inc_amask"

const string
TABLE_ACCOUNTS = "accounts",
TABLE_CHARACTERS = "characters";


int GetAccountID(object oPC);

int GetOrCreateAccountID(object oPC);

int GetCharacterID(object oPC);

int GetOrCreateCharacterID(object oPC);

int GetAccountIsDM(object oPC);


void UpdateMessageCount(object oPC, int nMessages);

object GetPCByAID(int nAID);

object GetPCByCID(int nCID);

// notifies oPC about his character not in the database,
// and does some log output
void CharacterError(object oPC, string sLog = "Character not found");

// Saves oPC into the database, updating all statistics and stuff.
// Returns the character ID, or 0 on failure.
int SaveCharacter(object oPC, int bIsLogin = FALSE);


// Returns true if this char may join the fray.
// Notifies the player too!
// int GetMayPlay(object oPC);

/* Implementation */

void UpdateMessageCount(object oPC, int nMessages) {
	int nCID = GetCharacterID(oPC);
	if (!nCID)
		return;

	pQ("update characters set messages = messages + " + IntToString(nMessages) + 
		" where id = " + IntToString(nCID) + " limit 1;");
}

object GetPCByAID(int nAID) {
	object oPC = GetFirstPC();
	while ( GetIsObjectValid(oPC) ) {
		if ( GetAccountID(oPC) == nAID )
			return oPC;

		oPC = GetNextPC();
	}
	return OBJECT_INVALID;
}

object GetPCByCID(int nCID) {
	object oPC = GetFirstPC();
	while ( GetIsObjectValid(oPC) ) {
		if ( GetCharacterID(oPC) == nCID )
			return oPC;

		oPC = GetNextPC();
	}
	return OBJECT_INVALID;
}

void CharacterError(object oPC, string sLog = "Character not found") {
	ToPC(
		"Dein Eintrag in der Datenbank wurde nicht gefunden.  Vielleicht ist die Datenbank gerade am Boden; oder es ist ein Bug.  Versuche es in 5 Minuten noch einmal - dann melde es einem SL.",
		oPC);
	WriteTimestampedLogEntry("Error: " + sLog + "; for " + GetName(oPC) + "/" + GetPCPlayerName(oPC));
}


int GetAccountID(object oPC) {
	string sAcc = GetPCName(oPC);
	if ( "" == sAcc )
		return 0;

	if ( GetLocalInt(GetModule(), sAcc + "_aid") )
		return GetLocalInt(GetModule(), sAcc + "_aid");


	pQ("select id from " +
		TABLE_ACCOUNTS + " where account = " + pE(GetPCName(oPC)) + " limit 1;");
	if ( !pF() )
		return 0;
	else {
		int nID = StringToInt(pG(1));
		SetLocalInt(GetModule(), sAcc + "_aid", nID);
		return nID;
	}
}


int GetAccountIsDM(object oPC) {
	if ( GetLocalInt(oPC, "dm") )
		return 1;

	int iID = GetAccountID(oPC);
	if ( 0 == iID )
		return 0;

	pQ("select dm from " + TABLE_ACCOUNTS + " where id = " + IntToString(iID) + " limit 1;");
	if ( !pF() )
		return 0;

	return pG(1) == "t";
}


int GetCharacterID(object oPC) {
	object oMod = GetModule();
	string sAcc = GetName(oPC);

	if ( sAcc == "" )
		return 0;

	string sDMFlag = GetIsDM(oPC) ? "_dm" : "";

	if ( GetLocalInt(oMod, sAcc + sDMFlag + "_cid") )
		return GetLocalInt(oMod, sAcc + sDMFlag + "_cid");

	int nAID = GetAccountID(oPC);
	if ( 0 == nAID )
		return 0;


	pQ("select id from " +
		TABLE_CHARACTERS +
		" where  account = " + IntToString(nAID) + " and character = " + pE(sAcc) + " limit 1;");

	if ( !pF() )
		return 0;
	else {
		int nID = StringToInt(pG(1));
		SetLocalInt(oMod, sAcc + sDMFlag + "_cid", nID);
		return nID;
	}
}



int GetOrCreateAccountID(object oPC) {
	string sAcc = GetPCName(oPC);
	if ( "" == sAcc )
		return 0;

	if ( GetLocalInt(GetModule(), sAcc + "_aid") )
		return GetLocalInt(GetModule(), sAcc + "_aid");

	string sAccount = GetPCName(oPC);

	if ( sAccount == "" )
		return 0;

	sAccount = pE(sAccount);

	pQ("select id from " + TABLE_ACCOUNTS + " where account = " + sAccount + " limit 1;");
	if ( !pF() )
		pQ("insert into " +
			TABLE_ACCOUNTS + " (account, create_on) values(" + sAccount + ");");

	pQ("select id from " + TABLE_ACCOUNTS + " where account = " + sAccount + " limit 1;");
	if ( !pF() )
		return 0;
	else {
		int nID = StringToInt(pG(1));
		SetLocalInt(GetModule(), sAcc + "_aid", nID);
		return nID;
	}
}



int GetOrCreateCharacterID(object oPC) {
	object oMod = GetModule();
	string sAcc = GetName(oPC);
	if ( sAcc == "" )
		return 0;

	string sDMFlag = GetIsDM(oPC) ? "dm_" : "";

	if ( GetLocalInt(oMod, sAcc + sDMFlag + "_cid") )
		return GetLocalInt(oMod, sAcc + sDMFlag + "_cid");


	int nAID = GetAccountID(oPC);
	if ( 0 == nAID )
		return 0;

	string
	sAID = IntToString(nAID),
	sChar = pE(GetName(oPC));

	pQ("select id from " +
		TABLE_CHARACTERS +
		" where account = " + IntToString(nAID) + " and character =" + sChar + " limit 1;");

	if ( !pF() )
		pQ("insert into " +
			TABLE_CHARACTERS +
			" (account, character, create_ip, create_key) values(" +
			sAID +
			", " + sChar + ", '" + GetPCIPAddress(oPC) + "', '" + GetPCPublicCDKey(oPC) + "');");

	pQ("select id from " +
		TABLE_CHARACTERS +
		" where account = " + IntToString(nAID) + " and character = " + sChar + " limit 1;");

	if ( !pF() )
		return 0;
	else {
		int nID = StringToInt(pG(1));
		SetLocalInt(oMod, sAcc + sDMFlag + "_cid", nID);
		return nID;
	}
}


int SaveCharacter(object oPC, int bIsLogin = FALSE) {
	if ( GetIsDM(oPC) )
		return 0;

	string
	sChar = pE(GetName(oPC)),
	sAccount = pE(GetPCName(oPC)),
	sKey = GetPCPublicCDKey(oPC),
	sIP = GetPCIPAddress(oPC),
	sDesc = "",    //pE(GetDescription(oPC));
	sGender = "";
	switch ( GetGender(oPC) ) {
		case GENDER_FEMALE:
			sGender = "f";
			break;
		case GENDER_MALE:
			sGender = "m";
			break;
		case GENDER_BOTH:
		case GENDER_NONE:
		case GENDER_OTHER:
			sGender = "n";
			break;
	}


	/* ACCOUNT */

	int nAID = GetOrCreateAccountID(oPC);
	string sAID = IntToString(nAID);

	if ( nAID == 0 ) {
		audit("error", oPC, audit_fields("info", "Cannot find or create account"), "cdb");
		SendMessageToAllDMs(
			"Warning: Query in inc_cdb#SaveCharacter failed: Cannot find or create account for " +
			sChar + ", " + sAccount + ".");
		return 0;
	}

	/* CHARACTER */

	pQ("select id from characters where  account = " +
		sAID + " and character = " + sChar + " limit 1;");

	// Create some initial record.
	if ( !pF() ) {
		SendMessageToAllDMs("New character: " + GetName(oPC) + "(" + GetPCName(oPC) + ")");
		pQ(
			"insert into characters (account, character, create_ip, create_key) values("
			+
			sAID + ", " + sChar + ", '" + sIP + "', '" + sKey + "');");
		//audit("new", oPC, audit_fields("info", "new character"), "cdb");
	}


	pQ("select id, create_key, other_keys, status from characters where account=" +
		sAID + " and character=" + sChar + " limit 1;");
	pF();


	string
	sID = pG(1),     // IntToString(StringToInt(GetMaxID("characters"))),
	sCreateKey = pG(2),
	sOtherKeys = pG(3),
	sStatus = pG(4);

	if ( sID == "" ) {
		audit("error", oPC, audit_fields("info", "Cannot find or create character"), "cdb");
		SendMessageToAllDMs(
			"Warning: Query in inc_cdb#SaveCharacter failed: Cannot create character record for " +
			sChar + ", " + sAccount + ".");
		return 0;
	}


	int nCID = StringToInt(sID);

	string sDMFlag = GetIsDM(oPC) ? "dm_" : "";
	SetLocalInt(GetModule(), GetPCName(oPC) + sDMFlag + "_cid", nCID);

	int nGold = Money2Value(CountCreatureMoney(oPC, 0));
	// Update base data
	pQ("update characters set " +
		"race = " + pE(RaceToString(oPC)) + ", " +
		"subrace = " + pE(GetSubRace(oPC)) + ", " +
		"alignment_moral = '" + IntToString(GetAlignmentGoodEvil(oPC)) + "', " +
		"alignment_ethical = '" + IntToString(GetAlignmentLawChaos(oPC)) + "', " +
		"xp = '" + IntToString(GetXP(oPC)) + "', gold = '" + IntToString(nGold) + "', " +

		"sex = '" + sGender + "', " +
		"age = '" + IntToString(GetAge(oPC)) + "', " +
		"deity = " + pE(GetDeity(oPC)) + ", " +

		"str = '" + IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH, 1))  + "', " +
		"dex = '" + IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY, 1))  + "', " +
		"con = '" + IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION, 1))  + "', " +
		"wis = '" + IntToString(GetAbilityScore(oPC, ABILITY_WISDOM, 1))  + "', " +
		"int = '" + IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE, 1))  + "', " +
		"chr = '" + IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA, 1))  + "', " +

		"reflex = '" + IntToString(GetReflexSavingThrow(oPC))  + "', " +
		"fortitude = '" + IntToString(GetFortitudeSavingThrow(oPC))  + "', " +
		"will = '" + IntToString(GetWillSavingThrow(oPC))  + "'" +

		" where id='" + sID + "' limit 1;");

	// XXX update nwnx_functions to work with 1.67
	//pQ("update characters set description = '" + sDesc + "' where id='" + sID + "' limit 1;");



	// Update player position
	vector v = GetPosition(oPC);
	string sArea = pE(GetTag(GetArea(oPC)));
	pQ("update characters set area = " + sArea + ", x = '" + FloatToString(v.x) + "', " +
		"y = '" +
		FloatToString(v.y) +
		"', z = '" + FloatToString(v.z) + "', f = '" + FloatToString(GetFacing(oPC)) + "' limit 1;");


	if ( bIsLogin ) {

		// Update last login time
		pQ("update characters set last_login=now() where id='" + sID + "' limit 1;");


		// Find domains
		string
		sDomain1,
		sDomain2;

		if ( GetHasFeat(FEAT_AIR_DOMAIN_POWER, oPC) )
			sDomain1 = "Luft";
		if ( GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Tiere" ) : ( sDomain1 = "Tiere" );
		if ( GetHasFeat(FEAT_DEATH_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Tod" ) : ( sDomain1 = "Tod" );
		if ( GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Zerstoerung" ) : ( sDomain1 = "Zerstoerung" );
		if ( GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Erde" ) : ( sDomain1 = "Erde" );
		if ( GetHasFeat(FEAT_EVIL_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Boeses" ) : ( sDomain1 = "Boeses" );
		if ( GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Feuer" ) : ( sDomain1 = "Feuer" );
		if ( GetHasFeat(FEAT_GOOD_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Gutes" ) : ( sDomain1 = "Gutes" );
		if ( GetHasFeat(FEAT_HEALING_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Heilung" ) : ( sDomain1 = "Heilung" );
		if ( GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Wissen" ) : ( sDomain1 = "Wissen" );
		if ( GetHasFeat(FEAT_LUCK_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Glueck" ) : ( sDomain1 = "Glueck" );
		if ( GetHasFeat(FEAT_MAGIC_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Magie" ) : ( sDomain1 = "Magie" );
		if ( GetHasFeat(FEAT_PLANT_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Pflanzen" ) : ( sDomain1 = "Pflanzen" );
		if ( GetHasFeat(FEAT_PROTECTION_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Schutz" ) : ( sDomain1 = "Schutz" );
		if ( GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Staerke" ) : ( sDomain1 = "Staerke" );
		if ( GetHasFeat(FEAT_SUN_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Sonne" ) : ( sDomain1 = "Sonne" );
		if ( GetHasFeat(FEAT_TRAVEL_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Reisen" ) : ( sDomain1 = "Reisen" );
		if ( GetHasFeat(FEAT_TRICKERY_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Tricks" ) : ( sDomain1 = "Tricks" );
		if ( GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Krieg" ) : ( sDomain1 = "Krieg" );
		if ( GetHasFeat(FEAT_WATER_DOMAIN_POWER, oPC) )
			( sDomain1 != "" ) ? ( sDomain2 = "Wasser" ) : ( sDomain1 = "Wasser" );

		// Update classes and stuff
		pQ("update characters set " +
			"class1 = " + pE(ClassToString(GetClassByPosition(1, oPC))) + ", " +
			"class1_level = '" + IntToString(GetLevelByClass(GetClassByPosition(1, oPC), oPC)) + "', " +
			"class2 = " + pE(ClassToString(GetClassByPosition(2, oPC))) + ", " +
			"class2_level = '" + IntToString(GetLevelByClass(GetClassByPosition(2, oPC), oPC)) + "', " +
			"class3 = " + pE(ClassToString(GetClassByPosition(3, oPC))) + ", " +
			"class3_level = '" + IntToString(GetLevelByClass(GetClassByPosition(3, oPC), oPC)) + "', " +

			"familiar_class = " + pE(FamiliarToString(oPC)) + ", " +
			"familiar_name = " + pE(GetFamiliarName(oPC)) + ", " +

			"domain1 = '" + sDomain1 + "', domain2='" + sDomain2 + "' " +

			" where id='" + sID + "' limit 1;");


		// Update keys, if necessary.
		if ( sCreateKey != sKey && !TestStringAgainstPattern("**" + sKey + "**", sOtherKeys) ) {
			if ( sOtherKeys != "" )
				sOtherKeys += " ";
			sOtherKeys += sKey;
			pQ("update characters set other_keys='" +
				sOtherKeys + "' where id='" + sID + "' limit 1;");
		}

		pQ("update characters set login_time = now() where id='" + sID + "' limit 1;");
	}

	return nCID;
}
