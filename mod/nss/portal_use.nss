#include "inc_decay"
#include "inc_mysql"
#include "inc_persist"
#include "inc_subr_data"

void main() {
	string sTarget = GetLocalString(OBJECT_SELF, "ziel");
	object oPC = GetPCSpeaker();
	location lLoc = GetLocation(GetWaypointByTag(sTarget));


	// Last-Login Portal
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
			location lPC = Location(oArea, vPosition, fOrientation);
			AssignCommand(oPC, ActionJumpToLocation(lPC));
		}
	} else {
		AssignCommand(oPC, JumpToLocation(lLoc));
	}
}
