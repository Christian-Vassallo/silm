// Run on module start
void pSQLInit();

// Run a query
void pQ(string sSQL);

// Run a query
void pSQLQuery(string sSQL);

// Escape and return a string using 'xx' || 'xx'
string pE(string str);

// Escape and return a string using 'xx' || 'xx'
string pSQLEscape(string str);

// Begin transaction
void pB();

// Commit transaction
void pC();

// Rollback transaction
void pR();

// Abort transaction
void pA();

// Returns the last SQL query executed (globally!).
string pSQLGetLastQuery();


// Fetch next row. Returns 1 on success, 0 on no more rows
int pF();
int pSQLFetch();

// Returns column n in the result set
string pG(int n);
string pGs(int n);

// Returns column n in the result set as int
int pGi(int n);

// Returns column n in the result set as float
float pGf(int n);

// Returns column n in the result set as boolean (0 or 1)
int pGb(int n);

// Return value of column iCol in the current row of result set sResultSetName
string pSQLGetData(int iCol);

// Return a int formatted for insert or update
string pSi(int n, int b0isNULL = TRUE);

// Return a string formatted for insert or update
string pSs(string s, int bEmptyIsNULL = FALSE);

// Return a float formatted for insert or update
string pSf(float f, int b0isNULL = TRUE);

// Return a bool formatted for insert or update (0 = false, rest = true)
string pSb(int b);



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
	pQ("set client_encoding = 'iso-8859-15';");
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
	pSQLExecDirect(sSQL + ";");
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
	pSQLQuery("ROLLBACK;");
}

void pA() {
	pSQLQuery("ABORT;");
}

string pG(int n) {
	return pSQLGetData(n);
}
string pGs(int n) {
	return pSQLGetData(n);
}

int pGi(int n) {
	return StringToInt(pSQLGetData(n));
}

float pGf(int n) {
	return StringToFloat(pSQLGetData(n));
}

int pGb(int n) {
	return pSQLGetData(n) == "t";
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
			new += "'||chr(39)||'";
			last = i + 1;
			count += 1;
		} else
			new += c;
	}
	new += "'";
	return new;
}


string pSi(int n, int b0isNULL = TRUE) {
	return b0isNULL && 0 == n ? "NULL" : IntToString(n);
}

string pSs(string s, int bEmptyIsNULL = FALSE) {
	return bEmptyIsNULL && "" == s ? "NULL" : pE(s);
}

string pSf(float f, int b0isNULL = TRUE) {
	return b0isNULL && 0.0 == f ? "NULL" : FloatToString(f);
}

string pSb(int b) {
	return 0 == b ? "'f'" : "'t'";
}

