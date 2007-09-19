/////////////////////////////////////////////////////////////
// : 4byte_npc_onenter
//////////////////////////////////////////////////////////////
// : Goldener Weg Superserver ;-) Scriptvault      VORLAGE !!
// : Tribute to : Elbeprinz aka Tristan
// : Modified by ZuMe
/////////////////////////////////////////////////////////////
// : Wenn ein PC den Ausloeser betritt, spricht der NPC ihn an
////////////////////////////////////////////////////////////


void main() {
	string sTag = "KENNUNG_NPC";        // Kennung NPC ersetzen ! //
	object oNPC = GetNearestObjectByTag(sTag);
	object oPC = GetEnteringObject();
	if ( GetIsPC(oPC) && FALSE == IsInConversation(oNPC) ) {
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oNPC, ClearAllActions());
		AssignCommand(oNPC, ActionMoveToObject(oPC));
		AssignCommand(oNPC, ActionStartConversation(oPC, "KENNUNG_NPC_GESPRAECH", FALSE, TRUE)); // Kennung des Gespraechs ersetzen !//
	}
}
