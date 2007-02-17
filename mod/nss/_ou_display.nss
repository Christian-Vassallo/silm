/* Scene Display
 *  Displays the associated text in database for this scene.
 */
#include "inc_chat_lib"
#include "inc_mysql"
#include "inc_dbplac"
#include "_colours"

void main() {
	object oPC = GetLastUsedBy();
	int nID = GetPlaceableID(OBJECT_SELF);

	string sText = "Kein Text hinterlegt.";
	if ( nID ) {
		SQLQuery("select text from scene_descriptions where pid = " + IntToString(nID) + " limit 1;");
		if ( SQLFetch() ) {
			sText = SQLGetData(1);
		}
	}

	//SendMessageToPC(oPC, sText);
	FloatingTextStringOnCreature(ColourisePlayerText(oPC, 0, sText, cLightBlue), oPC, FALSE);
}
