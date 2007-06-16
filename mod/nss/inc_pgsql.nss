void pSQLInit();


void pQ(string sSQL);
void pSQLQuery(string sSQL);

string pE(string str);
string pSQLEscape(string str);

void pB();
void pC();
void pR();

// Returns the last SQL query executed.
string pSQLGetLastQuery();

// Escape this string to be psql compatible
string pSQLEscape(string sString);


int pF();
// Position cursor on next row of the resultset
// Call this before using SQLGetData().
// returns: SQL_SUCCESS if there is a row
//          SQL_ERROR if there are no more rows
int pSQLFetch();

string pG(int n);
// Return value of column iCol in the current row of result set sResultSetName
string pSQLGetData(int iCol);


void pSQLSetSCORCOSQL(string sSQL);
void pSQLStoreObject(object oToStore);
object pSQLRetrieveObject(location loc, object oOwner);


/************************************/
/* Implementation                   */
/************************************/

// Functions for initializing APS and working with result sets

void pSQLInit() {
	int i;

	// Placeholder for ODBC persistence
	string sMemory;

	for ( i = 0; i < 8; i++ )  // reserve 8*128 bytes
		sMemory +=
			"................................................................................................................................";
	SetLocalString(GetModule(), "NWNX!PGSQL!SPACER", sMemory);
	pQ("set search_path = nwserver;");
	pQ("set client_encoding = 'iso-8859-1';");
}

string pSQLGetLastQuery() {
	return GetLocalString(GetModule(), "psql_last_query");
}

void pQ(string sSQL) {
	pSQLQuery(sSQL);
}


void pSQLExecDirect(string sSQL) {
	SetLocalString(GetModule(), "psql_last_query", sSQL);
	SetLocalString(GetModule(), "NWNX!PGSQL!EXEC", sSQL);
}

void pSQLQuery(string sSQL) {
	pSQLExecDirect(sSQL);
}

int pF() {
	return pSQLFetch();
}

int pSQLFetch() {
	string sRow;
	object oModule = GetModule();

	SetLocalString(oModule, "NWNX!PGSQL!FETCH", GetLocalString(oModule, "NWNX!PGSQL!SPACER"));
	sRow = GetLocalString(oModule, "NWNX!PGSQL!FETCH");
	if ( GetStringLength(sRow) > 0 ) {
		SetLocalString(oModule, "NWNX_PGSQL_CurrentRow", sRow);
		return TRUE;
	} else {
		SetLocalString(oModule, "NWNX_PGSQL_CurrentRow", "");
		return FALSE;
	}
}

void pB() {
	pSQLQuery("BEGIN;");
}

void pC() {
	pSQLQuery("COMMIT;");
}

void pR() {
	pSQLQuery("ROLLBACK");
}

string pG(int n) {
	return pSQLGetData(n);
}

string pSQLGetData(int iCol) {
	int iPos;
	string sResultSet = GetLocalString(GetModule(), "NWNX_PGSQL_CurrentRow");

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

string pE(string str) {
	return pSQLEscape(str);
}
string pSQLEscape(string str) {
	if ( -1 == FindSubString(str, "'") )
		return "'" + str + "'";

	int i = 0, last = 0;
	int count = 0;
	string c = "", new = "'";
	for ( i = 0; i < GetStringLength(str); i++ ) {
		c = GetSubString(str, i, 1);

		if ( c == "'" ) {
			new += "' || chr(39) || '";
			last = i + 1;
			count += 1;
		} else
			new += c;
	}
	new += "'";
	return new;
}

void pSQLSetSCORCOSQL(string sSQL) {
	SetLocalString(GetModule(), "NWNX!PGSQL!SETSCORCOSQL", sSQL);
}


object pSQLRetrieveObject(location loc, object oOwner) {
	return RetrieveCampaignObject("NWNX", "-", loc, oOwner);
}

void pSQLStoreObject(object oToStore) {
	StoreCampaignObject("NWNX", "-", oToStore);
}
