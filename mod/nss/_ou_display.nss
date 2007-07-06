/* Scene Display
 *  Displays the associated text in database for this scene.
 */
#include "inc_chat_lib"
#include "inc_pgsql"
#include "inc_dbplac"
#include "inc_colours"

void main() {
	object oPC = GetLastUsedBy();
	int nID = GetPlaceableID(OBJECT_SELF);

	string sText = "Kein Text hinterlegt.";
	if ( nID ) {
		pQ("select text from scene_descriptions where pid = " + pSi(nID) + " limit 1;");
		if ( pF() ) {
			sText = pGs(1);
		}
	}

	//SendMessageToPC(oPC, sText);
	FloatingTextStringOnCreature(ColourisePlayerText(oPC, 0, sText, cLightBlue), oPC, FALSE);
}
