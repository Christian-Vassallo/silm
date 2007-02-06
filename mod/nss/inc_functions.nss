// Get the AC of armor oObject
int GetArmorAC(object oObject);

// Set the AC of armor oObject
void SetArmorAC(object oObject, int iAC);

// Set the gold piece value of oObject
void SetGoldPieceValue(object oObject, int iValue);

// Set tag of oObject to sValue
void SetTag(object oObject, string sValue);

// Get description of oObject
// Works on items and placeables
string GetDescription(object oObject);

// Set description of oObject
// Works on items and placeables
void SetDescription(object oObject, string sValue);

// Dump oObject
// Developers use only
void ObjectDump(object oObject);


int GetArmorAC(object oObject) {
	string sAC;
	SetLocalString(oObject, "NWNX!FUNCTIONS!GETARMORAC", "      ");
	sAC = GetLocalString(oObject, "NWNX!FUNCTIONS!GETARMORAC");
	return StringToInt(sAC);
}

void SetArmorAC(object oObject, int iAC) {
	SetLocalString(oObject, "NWNX!FUNCTIONS!SETARMORAC", IntToString(iAC));
}

void SetGoldPieceValue(object oObject, int iValue) {
	SetLocalString(oObject, "NWNX!FUNCTIONS!SETGOLDPIECEVALUE", IntToString(iValue));
}

void SetTag(object oObject, string sValue) {
	SetLocalString(oObject, "NWNX!FUNCTIONS!SETTAG", sValue);
}

string GetDescription(object oObject) {
	if ( GetIsPC(oObject) )
		return "";

	string sDesc;
	SetLocalString(oObject, "NWNX!FUNCTIONS!GETDESCRIPTION",
		"                                                                                                                                                                                                                                                            ");
	sDesc = GetLocalString(oObject, "NWNX!FUNCTIONS!GETDESCRIPTION");
	return sDesc;
}

void SetDescription(object oObject, string sValue) {
	if ( GetIsPC(oObject) )
		return;

	SetLocalString(oObject, "NWNX!FUNCTIONS!SETDESCRIPTION", sValue);
}

void ObjectDump(object oObject) {
	SetLocalString(oObject, "NWNX!FUNCTIONS!OBJDUMP", "      ");
}
