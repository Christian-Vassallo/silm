#include "_gen"
#include "inc_mysql"
#include "inc_cdb"
#include "_audit"
#include "inc_char_rules"
#include "inc_currency"


/*
 * 	Warning: This table uses the new escape code that works flawlessly with special characters.
 */

void main() {
	object oPC = OBJECT_SELF;

	// Do not enter DMs or Non-PC-Wussies
	//if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
	//    return;

	//if (GetIsDM(oPC))
	//    return;

	if ( !GetIsPC(oPC) )
		return;

	int nCID = SaveCharacter(oPC, TRUE);

	int nAID = GetAccountID(oPC);
	string sAID = IntToString(nAID);

	SQLQuery("select `status`,`amask` from `accounts` where `id`='" + sAID + "' limit 1;");
	SQLFetch();
	string sAccountStatus = SQLGetData(1);
	int namask = StringToInt(SQLGetData(2));

	/* now set the runtime data stuff */

	if ( sAccountStatus == "reject" ) {
		SendMessageToPC(oPC, "Dieser Account darf derzeit nicht gespielt werden.");
		SetCommandable(0, oPC);
		return;
	} else if ( sAccountStatus == "ban" ) {
		SendMessageToPC(oPC, "Dieser Account darf derzeit nicht gespielt werden; er ist gebannt."); // Landet auch im Spieler-Logfile
		SetCommandable(0, oPC);
		BootPC(oPC); // bevor Gebietswechsel durch Startscript
		return;
	}

	string sAcc = GetPCName(oPC);
	if ( sAcc != "" )
		SetLocalInt(GetModule(), sAcc + "_amask", namask);

	if ( GetIsDM(oPC) || nCID == 0 )
		return;


	SQLQuery("select `status` from `characters` where `id`='" + IntToString(nCID) + "' limit 1;");
	SQLFetch();
	string sStatus = SQLGetData(1);

	int bMayEnterGame = TRUE;

	if ( sStatus == "new" || sStatus == "register" || sStatus == "new_register" ) {
		if ( CharacterNeedsRegistering(oPC) ) {
			SendMessageToPC(oPC,
				"Dieser Charakter ist noch nicht angemeldet und ist anmeldepflichtig.  Bitte melde ihn zuerst an, bevor du ihn spielst.");
			//SetCommandable(0, oPC);
			bMayEnterGame = FALSE;
		} else {
			SendMessageToPC(oPC,
				"Dieser Charakter ist noch nicht angemeldet.  Du kannst diesen Charakter spielen, bis du Level 5 erreichst. :o)");
			SetCommandable(1, oPC);
		}
	} else if ( sStatus == "register_accept" ) {
		SendMessageToPC(oPC,
			"Dieser Charakter ist noch nicht angemeldet und ist anmeldepflichtig.  Du kannst diesen Charakter jedoch trotzdem solange spielen. :o)");
		SetCommandable(1, oPC);
	} else if ( sStatus == "reject" ) {
		SendMessageToPC(oPC,
			"Dieser Charakter darf derzeit nicht gespielt werden; die Anmeldung wurde abgelehnt.");
		//SetCommandable(0, oPC);
		bMayEnterGame = FALSE;

	} else if ( sStatus == "ban" ) {
		SendMessageToPC(oPC, "Dieser Charakter darf derzeit nicht gespielt werden; er ist gebannt."); // Landet auch im Spieler-Logfile
		SetCommandable(0, oPC);
		bMayEnterGame = FALSE;
		BootPC(oPC); // bevor Gebietswechsel durch Startscript
	} else if ( sStatus == "accept" ) {
		SendMessageToPC(oPC, "Willkommen zurueck! :o)");
		SetCommandable(1, oPC);
	} else if ( sStatus == "dead" ) {
		SendMessageToPC(oPC,
			"Dieser Charakter ist tot.  Du kannst ihn leider nicht mehr spielen.  Beschwerden nimmt der celestische Rat von 12 bis 20 Uhr an jedem Werktage entgegen, ausser Mittwochs; da ist Pokerrunde mit den Eisgiganten anberaumt.");
		// SetCommandable(0, oPC);
		bMayEnterGame = FALSE;
	} else if ( sStatus == "delete" ) {
		SendMessageToPC(oPC,
			"Dieser Charakter wurde als zu loeschen markiert.  Du kannst ihn leider nicht mehr spielen.  Beschwerden nimmt der celestische Rat von 12 bis 20 Uhr an jedem Werktage entgegen, ausser Mittwochs; da ist Pokerrunde mit den Eisgiganten anberaumt.");
		// SetCommandable(0, oPC);
		bMayEnterGame = FALSE;
	}


	SetLocalInt(oPC, "may_enter_game", bMayEnterGame || GetIsDM(oPC));
}
