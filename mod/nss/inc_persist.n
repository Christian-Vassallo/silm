#include "inc_setting"

string GetDatabaseName(object oWhat, int iForcePC = 0) {
	if ( GetIsPC(oWhat) || iForcePC ) {
		string sName = GetName(oWhat);
		return gvGetStr("p_db_pref_player") + IntToString(GetStringLength(sName)) + "_" + sName;
	}

	return gvGetStr("p_db_pref_object") + GetTag(oWhat);
}

object GetLegacyDatabaseObject(object oWhat, int iForcePC = 0) {
	return OBJECT_INVALID;

	return ( GetIsPC(oWhat) || iForcePC ) ? oWhat : OBJECT_INVALID;
}

void SetLegacyPersistentInt(object oWho, string sVarName, int iValue, int iForcePC = 0) {
	SetLocalInt(oWho, "PER_" + sVarName, iValue);
	SetCampaignInt(GetDatabaseName(oWho, iForcePC), sVarName, iValue, GetLegacyDatabaseObject(oWho, iForcePC));
}

void SetLegacyPersistentString(object oWho, string sVarName, string sValue, int iForcePC = 0) {
	SetLocalString(oWho, "PER_" + sVarName, sValue);
	SetCampaignString(GetDatabaseName(oWho, iForcePC), sVarName, sValue, GetLegacyDatabaseObject(oWho,
			iForcePC));
}

void SetLegacyPersistentFloat(object oWho, string sVarName, float fValue, int iForcePC = 0) {
	SetLocalFloat(oWho, "PER_" + sVarName, fValue);
	SetCampaignFloat(GetDatabaseName(oWho, iForcePC), sVarName, fValue, GetLegacyDatabaseObject(oWho,
			iForcePC));
}

void SetLegacyPersistentLocation(object oWho, string sVarName, location lValue, int iForcePC = 0) {
	SetLocalLocation(oWho, "PER_" + sVarName, lValue);
	SetCampaignLocation(GetDatabaseName(oWho, iForcePC), sVarName, lValue, GetLegacyDatabaseObject(oWho,
			iForcePC));
}

int GetLegacyPersistentInt(object oWho, string sVarName) {
	int iValue;
	if ( !( iValue = GetLocalInt(oWho, "PER_" + sVarName) ) ) {
		iValue = GetCampaignInt(GetDatabaseName(oWho), sVarName, GetLegacyDatabaseObject(oWho));
		SetLocalInt(oWho, "PER_" + sVarName, iValue);
	}
	return iValue;
}

string GetLegacyPersistentString(object oWho, string sVarName) {
	string sValue;
	if ( ( sValue = GetLocalString(oWho, "PER_" + sVarName) ) == "" ) {
		sValue = GetCampaignString(GetDatabaseName(oWho), sVarName, GetLegacyDatabaseObject(oWho));
		SetLocalString(oWho, "PER_" + sVarName, sValue);
	}
	return sValue;
}

float GetLegacyPersistentFloat(object oWho, string sVarName) {
	float fValue;
	if ( ( fValue = GetLocalFloat(oWho, "PER_" + sVarName) ) == 0.0 ) {
		fValue = GetCampaignFloat(GetDatabaseName(oWho), sVarName, GetLegacyDatabaseObject(oWho));
		SetLocalFloat(oWho, "PER_" + sVarName, fValue);
	}
	return fValue;
}

location GetLegacyPersistentLocation(object oWho, string sVarName) {
	return GetCampaignLocation(GetDatabaseName(oWho), sVarName, GetLegacyDatabaseObject(oWho));
}

