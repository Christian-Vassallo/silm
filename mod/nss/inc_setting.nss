/*
 * Global module settings
 */
#include "inc_pgsql"

const string
	GV_TABLE = "gv";


int gvSetInt(string sKey, int nValue);
int gvGetInt(string sKey);

string gvSetStr(string sKey, string sValue);
string gvGetStr(string sKey);

float gvSetFloat(string sKey, float fValue);
float gvGetFloat(string sKey);

string gvSetVar(string sKey, string sType, string sValue);
string gvGetVar(string sKey, string sType);

int gvExistsVar(string sKey, string sType);

// Imp


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
float gvSetFloat(string sKey, float fValue) {
	return StringToFloat(
		gvSetVar(sKey, "float", FloatToString(fValue))
	);
}

float gvGetFloat(string sKey) {
	return StringToFloat(
		gvGetVar(sKey, "float")
	);
}


string gvSetStr(string sKey, string sValue) {
	return gvSetVar(sKey, "string", sValue);
}
string gvGetStr(string sKey) {
	return gvGetVar(sKey, "string");
}


string gvSetVar(string sKey, string sType, string sValue) {
	if (gvExistsVar(sKey, sType))
		pQ("update " + GV_TABLE + " set value = " + pE(sValue) + 
			" where key = " + pE(sKey) + " and type = " + pE(sType) + 
			";");
	else
		pQ("insert into " + GV_TABLE + " (key, type, value) values(" +
			pE(sKey) + ", " + pE(sType) + ", " + pE(sValue) + 
			");"
		);
	return sValue;
}

string gvGetVar(string sKey, string sType) {
	string cacheKey = "gv_" + sType + "_" + sKey;
	if (GetLocalInt(GetModule(), cacheKey) > 0)
			return GetLocalString(GetModule(), cacheKey);

	pQ("select value, date_part('epoch', now())::int from " + GV_TABLE + " where " +
		" key = " + pE(sKey) + 
		" and type = " + pE(sType) + 
		";");
	if (pF()) {
		SetLocalString(GetModule(), cacheKey, pG(1));
		SetLocalInt(GetModule(), cacheKey, StringToInt(pG(2)));
		return pG(1);
	} else
		return "";
}

int gvExistsVar(string sKey, string sType) {
	pQ("select value from " + GV_TABLE + " where " +
		" key = " + pE(sKey) + 
		" and type = " + pE(sType) + 
		";");
	return 1 == pF();
}
