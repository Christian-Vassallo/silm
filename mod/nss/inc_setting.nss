/*
 * Global module settings
 */
const string
	GV_TABLE = "gv";


int gvSetInt(string sKey, int nValue);
int gvGetInt(string sKey);


string gvSetVar(string sKey, string sType, string sValue);
string gvGetVar(string sKey, string sType);
int gvExistsVar(string sKey, string sType);


int gvSetInt(string sKey, int nValue) {
	return StringToInt(
		gvSetVar(sKey, "int", IntToString(nValue))
	);
}
int gvGetInt(string sKey) {
	return StringToInt(
		gvGetVar(sKey, "int")
	);
}


string gvSetVar(string sKey, string sType, string sValue) {

	if (gvExistsVar(sKey, sType))
		SQLQuery("update " + GV_TABLE + " set `value` = " + SQLEscape(sValue) + 
			" where `key` = " + SQLEscape(sKey) + " and `type` = " + SQLEscape(sType) + 
			" limit 1;");
	else
		SQLQuery("insert into " + GV_TABLE + " (`key`, `type`, `value`) values(" +
			SQLEscape(sKey) + ", " + SQLEscape(sType) + ", " + SQLEscape(sValue) + 
			") limit 1;"
		);

	return sValue;
}

string gvGetVar(string sKey, string sType) {
	SQLQuery("select `value` from " + GV_TABLE + " where " +
		" `key` = " + SQLEscape(sKey) + 
		" and `type` = " + SQLEscape(sType) + 
		" limit 1;");
	if (SQLFetch())
		return SQLGetData(1);
	else
		return "";
}

int gvExistsVar(string sKey, string sType) {
	SQLQuery("select `value` from " + GV_TABLE + " where " +
		" `key` = " + SQLEscape(sKey) + 
		" and `type` = " + SQLEscape(sType) + 
		" limit 1;");
	return 1 == SQLFetch();
}
