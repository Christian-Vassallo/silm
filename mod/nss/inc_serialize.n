const string
SERIALIZE_DELIMITER = "::";


string serialize(string sStringVarNames, string sIntVarNames, string sFloatVarNames, object oO = OBJECT_SELF)
{
	int iW = -1;
	string sR = "";

	string sSub = "";
	iW = FindSubString(sStringVarNames, SERIALIZE_DELIMITER);
	while ( iW != -1 ) {
		sSub = GetSubString(sStringVarNames, 0, iW);
		sStringVarNames = GetSubString(sStringVarNames, iW + GetStringLength(SERIALIZE_DELIMITER), 2048);
		sR += "string:" + sSub + ":" + GetLocalString(oO, sSub) + "::";
		iW = FindSubString(sStringVarNames, SERIALIZE_DELIMITER);
	}
	sR += "string:" + sSub + ":" + GetLocalString(oO, sSub) + "::";

}



void deserialize(object o, string sSerialized) {}
