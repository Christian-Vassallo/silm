// Name     : Avlis Persistence System include
// Purpose  : Various APS/NWNX2 related functions
// Authors  : Ingmar Stieger, Adam Colon, Josh Simon
// Modified : December 26, 2004

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

#include "inc_loctools"


/************************************/
/* Return codes                     */
/************************************/

const int SQL_ERROR = 0;
const int SQL_SUCCESS = 1;

/************************************/
/* Function prototypes              */
/************************************/

// Setup placeholders for ODBC requests and responses
void SQLInit();


// Alias for SQLExecDirect
void SQLQuery(string sSQL);

/*
void TransactionStart();
void TransactionCancel();
void TransactionCommit();
*/

// Returns the last SQL query executed.
string SQLGetLastQuery();

// Does the NEW, better escaping. Not compatible with SQL*codeSpecialChars().
string SQLEscape(string sString);

// Position cursor on next row of the resultset
// Call this before using SQLGetData().
// returns: SQL_SUCCESS if there is a row
//          SQL_ERROR if there are no more rows
int SQLFetch();

// Return value of column iCol in the current row of result set sResultSetName
string SQLGetData(int iCol);


// Set oObject's persistent string variable sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwdata)
void SetPersistentData(object oPC, string sType, string sVarName, string sValue, int iExpiration = 0,
					   string sTable = "var");

string GetPersistentData(object oPC, string sType, string sVarName, string sTable = "var");


// (private function) Replace special character ' with ~
string SQLEncodeSpecialChars(string sString);

// (private function)Replace special character ' with ~
string SQLDecodeSpecialChars(string sString);



// Set oObject's persistent object with sVarName to sValue
// Optional parameters:
//   iExpiration: Number of days the persistent variable should be kept in database (default: 0=forever)
//   sTable: Name of the table where variable should be stored (default: pwobjdata)
void SetPersistentObject(object oObject, string sVarName, object oObject2, int iExpiration = 0,
						 string sTable = "pwobjdata");


// Get oObject's persistent object sVarName
// Optional parameters:
//   sTable: Name of the table where object is stored (default: pwobjdata)
// * Return value on error: 0
object GetPersistentObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID,
						   string sTable = "pwobjdata");


/************************************/
/* Implementation                   */
/************************************/

// Functions for initializing APS and working with result sets

void SQLInit() {
	int i;

	// Placeholder for ODBC persistence
	string sMemory;

	for ( i = 0; i < 8; i++ )  // reserve 8*128 bytes
		sMemory +=
			"................................................................................................................................";
	SetLocalString(GetModule(), "NWNX!ODBC!SPACER", sMemory);
}

string SQLGetLastQuery() {
	return GetLocalString(GetModule(), "sql_last_query");
}

void SQLExecDirect(string sSQL) {
	SetLocalString(GetModule(), "sql_last_query", sSQL);
	SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sSQL);
}

int SQLFetch() {
	string sRow;
	object oModule = GetModule();

	SetLocalString(oModule, "NWNX!ODBC!FETCH", GetLocalString(oModule, "NWNX!ODBC!SPACER"));
	sRow = GetLocalString(oModule, "NWNX!ODBC!FETCH");
	if ( GetStringLength(sRow) > 0 ) {
		SetLocalString(oModule, "NWNX_ODBC_CurrentRow", sRow);
		return SQL_SUCCESS;
	} else {
		SetLocalString(oModule, "NWNX_ODBC_CurrentRow", "");
		return SQL_ERROR;
	}
}

string SQLGetData(int iCol) {
	int iPos;
	string sResultSet = GetLocalString(GetModule(), "NWNX_ODBC_CurrentRow");

	// find column in current row
	int iCount = 0;
	string sColValue = "";

	iPos = FindSubString(sResultSet, "¬");
	if ( ( iPos == -1 ) && ( iCol == 1 ) ) {
		// only one column, return value immediately
		sColValue = sResultSet;
	} else if ( iPos == -1 ) {
		// only one column but requested column > 1
		sColValue = "";
	} else {
		// loop through columns until found
		while ( iCount != iCol ) {
			iCount++;
			if ( iCount == iCol )
				sColValue = GetStringLeft(sResultSet, iPos);
			else {
				sResultSet = GetStringRight(sResultSet, GetStringLength(sResultSet) - iPos - 1);
				iPos = FindSubString(sResultSet, "¬");
			}

			// special case: last column in row
			if ( iPos == -1 )
				iPos = GetStringLength(sResultSet);
		}
	}

	return sColValue;
}

void SetPersistentData(object oPC, string sType, string sVarName, string sValue, int iExpiration = 0,
					   string sTable = "var") {

	if ( !GetIsPC(oPC) ) {
		return;
	}

	// Warning warning XXX ugly hack to circumvent circular deps
	int nChar = GetLocalInt(oPC, "cid"); //GetCharacterID(oPC);
	if ( !nChar )
		return;

	string sID = IntToString(nChar);

	sVarName = SQLEscape(sVarName);
	sValue = SQLEscape(sValue);
	sType = SQLEscape(sType);

	SQLQuery("select `id` from `" +
		sTable +
		"` where `character`=" + sID + " and `name` = " + sVarName + " and `type = " + sType + " limit 1;");
	if ( SQLFetch() ) {
		sID = SQLGetData(1);
		SQLQuery("update `" + sTable + "` set `value` = " + sValue + " where `id` = " + sID + " limit 1;");
	} else {
		SQLQuery("insert into `" + sTable + "` (`character`,`type`,`name`,`value`) values( " +
			sID + ", " + sType + ", " + sVarName + ", " + sValue +
			");");
	}
}


string GetPersistentData(object oPC, string sType, string sVarName, string sTable = "var") {
	if ( !GetIsPC(oPC) )
		return "";

	int nChar = GetLocalInt(oPC, "cid"); //GetCharacterID(oPC);
	if ( !nChar )
		return "";

	string sID = IntToString(nChar);
	sType = SQLEscape(sType);
	sVarName = SQLEscape(sVarName);

	SQLQuery("select `value` from `" +
		sTable + "` where `character` = " + sID + " and `name` = " + sVarName + " limit 1;");

	if ( SQLFetch() )
		return SQLGetData(1);
	else {
		return "";
	}
}





// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions are a replace these quote with the tilde character

string SQLEncodeSpecialChars(string sString) {
	if ( FindSubString(sString, "'") == -1 )  // not found
		return sString;

	int i;
	string sReturn = "";
	string sChar;

	// Loop over every character and replace special characters
	for ( i = 0; i < GetStringLength(sString); i++ ) {
		sChar = GetSubString(sString, i, 1);
		if ( sChar == "'" )
			sReturn += "~";
		else
			sReturn += sChar;
	}
	return sReturn;
}

string SQLDecodeSpecialChars(string sString) {
	if ( FindSubString(sString, "~") == -1 )  // not found
		return sString;

	int i;
	string sReturn = "";
	string sChar;

	// Loop over every character and replace special characters
	for ( i = 0; i < GetStringLength(sString); i++ ) {
		sChar = GetSubString(sString, i, 1);
		if ( sChar == "~" )
			sReturn += "'";
		else
			sReturn += sChar;
	}
	return sReturn;
}

void SQLQuery(string sSQL) {
	SQLExecDirect(sSQL);
}

string SQLEscape(string str) {
	if ( -1 == FindSubString(str, "'") )
		return "CONCAT('" + str + "')";

	int i = 0, last = 0;
	int count = 0;
	string c = "", new = "CONCAT('";
	for ( i = 0; i < GetStringLength(str); i++ ) {
		c = GetSubString(str, i, 1);

		if ( c == "'" ) {
			new += "', char(39), '";
			last = i + 1;
			count += 1;
		} else
			new += c;
	}
	new += "')";
	return new;
}


void SetPersistentObject(object oOwner, string sVarName, object oObject, int iExpiration = 0,
						 string sTable = "pwobjdata") {
	string sPlayer;
	string sTag;

	if ( GetIsPC(oOwner) ) {
		sPlayer = SQLEscape(GetPCPlayerName(oOwner));
		sTag = SQLEscape(GetName(oOwner));
	} else {
		sPlayer = SQLEscape("~");
		sTag = SQLEscape(GetTag(oOwner));
	}
	sVarName = SQLEscape(sVarName);

	string sSQL = "SELECT player FROM " + sTable + " WHERE player=" + sPlayer +
				  " AND tag=" + sTag + " AND name=" + sVarName + "";
	SQLExecDirect(sSQL);

	if ( SQLFetch() == SQL_SUCCESS ) {
		// row exists
		sSQL = "UPDATE " + sTable + " SET val=%s,expire=" + IntToString(iExpiration) +
			   " WHERE player=" + sPlayer + " AND tag=" + sTag + " AND name=" + sVarName + "";
		SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
		StoreCampaignObject("NWNX", "-", oObject);
	} else {
		// row doesn't exist
		sSQL = "INSERT INTO " + sTable + " (player,tag,name,val,expire) VALUES" +
			   "(" + sPlayer + "," + sTag + "," + sVarName + ",%s," + IntToString(iExpiration) + ")";
		SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);
		StoreCampaignObject("NWNX", "-", oObject);
	}
}

object GetPersistentObject(object oObject, string sVarName, object oOwner = OBJECT_INVALID,
						   string sTable = "pwobjdata") {
	string sPlayer;
	string sTag;
	object oModule;

	if ( GetIsPC(oObject) ) {
		sPlayer = SQLEscape(GetPCPlayerName(oObject));
		sTag = SQLEscape(GetName(oObject));
	} else {
		sPlayer = SQLEscape("~");
		sTag = SQLEscape(GetTag(oObject));
	}
	sVarName = SQLEscape(sVarName);

	string sSQL = "SELECT val FROM " + sTable + " WHERE player=" + sPlayer +
				  " AND tag=" + sTag + " AND name=" + sVarName + "";
	SetLocalString(GetModule(), "NWNX!ODBC!SETSCORCOSQL", sSQL);

	if ( !GetIsObjectValid(oOwner) )
		oOwner = oObject;
	return RetrieveCampaignObject("NWNX", "-", GetLocation(oOwner), oOwner);
}
