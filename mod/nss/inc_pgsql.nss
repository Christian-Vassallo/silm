#include "inc_pgsql_base"
#include "inc_debug"

// set a string for ? replacement and escaping
void ppP(string sQuery);

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
	d("insert(" + sQuery + ", " + sToInsert + "), current_offset = " + IntToString(nOffset), "pgsql");

	string sPostOffset = GetSubString(sQuery, nOffset, 4096);

	int nQPos = FindSubString("?", sPostOffset) + nOffset;
	
	d("offset_str = " + sPostOffset + ", nqpos = " + IntToString(nQPos), "pgsql");

	if (-1 == nQPos)
		return sQuery;
	
	string sPre = GetSubString(sQuery, 0, nQPos);
	string sPost = GetSubString(sQuery, nQPos + 1, 4096);

	d("pre = " + sPre + ", post = " + sPost, "pgsql");

	SetLocalInt(GetModule(), "pp_cur_q_offset", nOffset + 1 + GetStringLength(sToInsert));
	d("new_offset = " + IntToString(nOffset + 1 + GetStringLength(sToInsert)), "pgsql");
	
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

void ppSb(int b, int bNegativeIsNULL = FALSE) {
	string q = ppGetCurrentQuery();
	q = ppInsertIntoQueryAtNextPosition(q, pSb(b));
	d("ppSb() -> " + q, "pgsql");
	ppSetCurrentQuery(q);
}


void ppSi(int n, int b0isNULL = TRUE) {
	string q = ppGetCurrentQuery();
	q = ppInsertIntoQueryAtNextPosition(q, pSi(n, b0isNULL));
	d("ppSi() -> " + q, "pgsql");
	ppSetCurrentQuery(q);
}

void ppSs(string s, int bEmptyIsNull = FALSE) {
	string q = ppGetCurrentQuery();
	q = ppInsertIntoQueryAtNextPosition(q, pSs(s, bEmptyIsNull));
	d("ppSs() -> " + q, "pgsql");
	ppSetCurrentQuery(q);
}

void ppSf(float f, int b0isNULL = TRUE) {
	string q = ppGetCurrentQuery();
	q = ppInsertIntoQueryAtNextPosition(q, pSf(f, b0isNULL));
	d("ppSf() -> " + q, "pgsql");
	ppSetCurrentQuery(q);
}
