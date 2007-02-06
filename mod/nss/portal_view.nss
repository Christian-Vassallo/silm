#include "inc_mysql"

void main() {
	string sTarget = GetLocalString(OBJECT_SELF, "ziel");
	string sCutScene = GetLocalString(OBJECT_SELF, "cutscene");
	object oPC = GetPCSpeaker();
	location lLocOrginal = GetLocation(oPC);
	location lLocTarget;
	if ( sTarget == "LastLogin" ) {
		string sCharName = SQLEncodeSpecialChars(GetName(oPC));
		string sPlayerName = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
		string sSQL = "SELECT AreaTag, X, Y, Z, Richtung FROM tab_chars WHERE Char_Name='" +
					  sCharName + "' AND GSA_Account='" + sPlayerName + "';";
		SQLExecDirect(sSQL);
		if ( SQLFetch() == SQL_SUCCESS ) {
			float fX = StringToFloat(SQLGetData(2));
			float fY = StringToFloat(SQLGetData(3));
			float fZ = StringToFloat(SQLGetData(4));
			float fOrientation = StringToFloat(SQLGetData(5));
			vector vPosition = Vector(fX, fY, fZ);
			object oArea = GetObjectByTag(SQLGetData(1));
			lLocTarget = Location(oArea, vPosition, fOrientation);
		}
	} else {
		lLocTarget = GetLocation(GetWaypointByTag(sTarget));
	}
	SetLocalString(oPC, "cutscene", sCutScene);
	AssignCommand(oPC, JumpToLocation(lLocTarget));
}
