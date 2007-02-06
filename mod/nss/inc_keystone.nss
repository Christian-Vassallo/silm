#include "inc_mysql"

// Enable oder Disable the Authorisation for KeyStone oItem
void UseKeyStone(object oOwner, object oPC, object oItem);

// Checks the Authorisation an Returns TRUE if authorised or FALSE if not
int CheckKeyStone(string sKeyStone, object oPC);


// Enable oder Disable the Authorisation for KeyStone oItem
void UseKeyStone(object oOwner, object oPC, object oItem) {
	string sKeyStone = GetTag(oItem);
	string sCharName = SQLEncodeSpecialChars(GetName(oPC));
	string sPlayerName = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sSQL = "SELECT " +
				  sKeyStone +
				  " FROM tab_chars WHERE Char_Name ='" +
				  sCharName + "' AND GSA_Account='" + sPlayerName + "';";
	//SendMessageToPC(oOwner, sSQL);
	SQLExecDirect(sSQL);
	if ( SQLFetch() == SQL_SUCCESS ) {
		string sCheck = SQLGetData(1);
		if ( sCheck == "TRUE" ) {
			sSQL = "UPDATE tab_chars SET " +
				   sKeyStone +
				   "='FALSE' WHERE Char_Name ='" + sCharName + "' AND GSA_Account='" + sPlayerName + "';";
			SQLExecDirect(sSQL);
			SendMessageToPC(oOwner, "Zugangsberechtigung fuer " + GetName(oPC) + " entzogen.");
		} else {
			sSQL = "UPDATE tab_chars SET " +
				   sKeyStone +
				   "='TRUE' WHERE Char_Name ='" + sCharName + "' AND GSA_Account='" + sPlayerName + "';";
			SQLExecDirect(sSQL);
			SendMessageToPC(oOwner, "Zugangsberechtigung fuer " + GetName(oPC) + " erstellt.");
		}
	}
}

int CheckKeyStone(string sKeyStone, object oPC) {
	int nReturn = FALSE;
	string sCharName = SQLEncodeSpecialChars(GetName(oPC));
	string sPlayerName = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sSQL = "SELECT " +
				  sKeyStone +
				  " FROM tab_chars WHERE Char_Name ='" +
				  sCharName + "' AND GSA_Account='" + sPlayerName + "';";
	SQLExecDirect(sSQL);
	if ( SQLFetch() == SQL_SUCCESS ) {
		string sCheck = SQLGetData(1);
		if ( sCheck == "TRUE" ) {
			nReturn = TRUE;
		}
	}
	return nReturn;
}

