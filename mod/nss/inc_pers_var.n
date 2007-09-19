#include "inc_cdb"
#include "inc_mysql"

// Gets a persistent int on oTarget, which has to be a PC
int GetInt(string sName, object oTarget = OBJECT_SELF, int bCache = TRUE);

// Gets a persistent string on oTarget, which has to be a PC
string GetStr(string sName, object oTarget = OBJECT_SELF, int bCache = TRUE);

void SetInt(string sName, int nVal, object oTarget = OBJECT_SELF, int bCache = TRUE);
void SetStr(string sName, string sVal, object oTarget = OBJECT_SELF, int bCache = TRUE);




int GetInt(string sName, object oTarget = OBJECT_SELF, int bCache = TRUE) {
	if ( bCache && GetLocalInt(OBJECT_SELF, sName) )
		return GetLocalInt(OBJECT_SELF, sName);

	int nCID = GetCharacterID(oTarget);
	if ( !nCID )
		return 0;

	string sRet = GetPersistentData(oTarget, "int", sName);

	return StringToInt(sRet);
}


string GetStr(string sName, object oTarget = OBJECT_SELF, int bCache = TRUE) {
	int nCID = GetCharacterID(oTarget);
	if ( !nCID )
		return "";

	return GetPersistentData(oTarget, "string", sName);
}



void SetInt(string sName, int nVal, object oTarget = OBJECT_SELF, int bCache = TRUE) {
	SetPersistentData(oTarget, "int", sName, IntToString(nVal));
}

void SetStr(string sName, string sVal, object oTarget = OBJECT_SELF, int bCache = TRUE) {
	SetPersistentData(oTarget, "string", sName, sVal);
}

