#include "inc_pgsql"

// set a string for ? replacement and escaping
void ppP(string sQuery);

void ppi(int n, int b0isNULL = TRUE);
void pps(string s);
void ppf(float f, int b0isNULL = TRUE);
void ppl(location l);

// Send the query
void ppQ();


string ppGetCurrentQuery();
void ppSetCurrentQuery(string sQuery);

int ppGetCurrentOffset();


// Reset query
void ppR();

string ppInsertIntoQueryAtNextPosition(string sQuery, string sToInsert);


string ppGetCurrentQuery() {
	return GetLocalString(GetModule(), "pp_cur_q");
}

void ppSetCurrentQuery(string sQuery) {
	SetLocalString(GetModule(), "pp_cur_q", sQuery);
}


string ppInsertIntoQueryAtNextPosition(string sQuery, string sToInsert) {
	int nOffset = GetLocalInt(GetModule(), "pp_cur_q_offset");

	string sPostOffset = GetSubString(sQuery, nOffset, 4096);

	int nQPos = FindSubString("?", sPostOffset) + nOffset;

	if (-1 == nQPos)
		return sQuery;
	
	string sPre = GetSubString(sQuery, 0, nQPos);
	string sPost = GetSubString(sQuery, nQPos + 1, 4096);

	SetLocalInt(GetModule(), "pp_cur_q_offset", nOffset + 1 + GetStringLength(sToInsert));
	
	return sPre + sToInsert + sPost;
}

void ppR() {
	SetLocalInt(GetModule(), "pp_cur_q_offset", 0);
	SetLocalString(GetModule(), "pp_cur_q", "");
}

void ppP(string sQuery) {
	SetLocalInt(GetModule(), "pp_cur_q_offset", 0);
	SetLocalString(GetModule(), "pp_cur_q", sQuery);
}

void ppQ() {
	pQ(ppGetCurrentQuery());
}


void ppSi(int n, int b0isNULL = TRUE) {
	string q = ppGetCurrentQuery();
	q = ppInsertIntoQueryAtNextPosition(q, pSi(n, b0isNULL));
	ppSetCurrentQuery(q);
}

void ppSs(string s, int bEmptyIsNull = FALSE) {
	string q = ppGetCurrentQuery();
	q = ppInsertIntoQueryAtNextPosition(q, pSs(s, bEmptyIsNull));
	ppSetCurrentQuery(q);
}

void ppSf(float f, int b0isNULL = TRUE) {
	string q = ppGetCurrentQuery();
	q = ppInsertIntoQueryAtNextPosition(q, pSf(f, b0isNull));
	ppSetCurrentQuery(q);
}
